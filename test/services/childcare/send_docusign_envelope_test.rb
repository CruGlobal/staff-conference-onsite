require 'test_helper'

class Childcare::SendDocusignEnvelopeTest < ServiceTestCase
  
  setup do
    @family = create :family
    @attendee = create :attendee, family: @family, first_name: 'Test', last_name: 'Recipient', email: 'test@example.com'
    @child = create :child, family: @family
    @family.primary_person = @attendee
    @family.save
  end
  
  stub_user_variable child_age_cutoff: 6.months.from_now.to_date

  test 'valid payload' do
    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      assert Childcare::SendDocusignEnvelope.call(@child)
      assert_equal(before + 1, ChildcareEnvelope.count)
    end
  end

  test 'if child already has an envelope marked as completed' do
    @completed = create :childcare_envelope, :completed, child: @child, recipient: @attendee

    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      exception = assert_raise(Childcare::SendDocusignEnvelope::SendEnvelopeError) { Childcare::SendDocusignEnvelope.call(@child) }
      assert_equal('Valid envelope already exists for child', exception.message )
      assert_equal(before, ChildcareEnvelope.count)
    end
  end
end
