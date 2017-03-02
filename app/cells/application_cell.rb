class ApplicationCell < Cell::ViewModel
  include Rails.application.helpers
  include MoneyRails::ActionViewExtension

  property :l

  # The reason to make a builder method return +nil+ is to avoid rending the
  # elements twice.  Arbre inserts HTML into a {Arbre::Context}, but also
  # returns the HTML from method call. Also, if a builder method returns a
  # string, it will be appended to the page a second time.
  def self.make_method_return_nil(*method_names)
    method_names.each do |name|
      define_method(name) do |*args, &blk|
        super(*args, &blk)
        nil
      end
    end
  end
end
