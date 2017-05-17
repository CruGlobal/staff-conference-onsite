# Apply a series of {CostAdjustment cost adjustments} to one or more costs.
#
# The adjustments are applied in this order:
#
#   1. The percent-based adjustments are summed and subtracted from the given
#      cost. ex: $100 - ($100 * (5% + 10% + 10%)) = $75
#   2. The price-based adjustments are then summed and subtracted from that
#      result. ex: $75 - ($10 + $5) = $60
#
# == Context Input
#
# [+context.charges+ [+Hash<String, Money>+]]
#   Each key is one of {CostAdjustment#cost_types} and each value is the total
#   cost in that category. The types are used to determine which adjustments
#   apply to each charge
# [+context.cost_adjustments+ [+Array<CostAdjustment>+]]
#
# == Context Output
#
# [+context.total_adjustments+ [+Money+]]
#   The total dollar-amount of all adjustments
# [+context.subtotal+ [+Money+]]
#   The total of all charges, before the {CostAdjustment cost adjustments} are
#   applied
# [+context.total+ [+Money+]]
#   The total of all charges, after the {CostAdjustment cost adjustments} are
#   applied
class ApplyCostAdjustments < ChargesService
  attr_accessor :charges, :cost_adjustments, :total_adjustments, :subtotal,
                :total

  after_initialize :default_values

  def call
    charges.each(&method(:add_to_total))
    constrain_total_adjustments
  end

  private

  def default_values
    self.total_adjustments ||= Money.empty
    self.subtotal ||= Money.empty
    self.total ||= Money.empty
  end

  def add_to_total(type, charge)
    type = type.to_s
    adjustments = cost_adjustments.select { |c| c.cost_type == type }
    increment_totals(charge, realize_adjustments(charge, adjustments))
  end

  def increment_totals(charge, adjust)
    self.total_adjustments += adjust
    self.subtotal += charge
    self.total += [Money.empty, charge - adjust].max
  end

  def realize_adjustments(charge, adjustments)
    percent_reduction = charge * total_percent(adjustments)
    price_reduction   = select_prices(adjustments).inject(Money.empty, &:+)

    [charge, percent_reduction + price_reduction].min
  end

  def total_percent(adjustments)
    select_percents(adjustments).inject(0, :+) / 100.0
  end

  def select_percents(adjustments)
    adjustments.select(&:percent?).map(&:percent)
  end

  def select_prices(adjustments)
    adjustments.select(&:price_cents?).map(&:price)
  end

  def constrain_total_adjustments
    self.total_adjustments = subtotal if total_adjustments > subtotal
  end
end