require 'rails_helper'

RSpec.describe ToastHelper do
  let(:message) do
    {
      message: 'A message',
      type: :notice,
      title: 'A title',
      options: '{ "some": options }'
    }
  end

  describe '#toasts' do
    context 'when one messages is given' do
      it 'renders a toast with the given message' do
        expect(helper).to receive(:content_for).with(:js).and_call_original
        expect(helper).to receive(:toastr)
          .with(message[:message], type: message[:type], title: message[:title], options: message[:options])

        helper.toasts message
      end
    end

    context 'when many messages are given' do
      let(:other_message) do
        {
          message: 'Other message',
          type: :notice,
          title: 'Other title',
          options: '{ "some other": options }'
        }
      end

      it 'renders a toast for each given message' do
        expect(helper).to receive(:content_for).with(:js).and_call_original

        expect(helper).to receive(:toastr)
          .with message[:message],
                type: message[:type],
                title: message[:title],
                options: message[:options]

        expect(helper).to receive(:toastr)
          .with other_message[:message],
                type: other_message[:type],
                title: other_message[:title],
                options: other_message[:options]

        helper.toasts message, other_message
      end
    end
  end

  describe '#toast' do
    it 'renders a toast with the given message' do
      expect(helper).to receive(:content_for).with(:js).and_call_original
      expect(helper).to receive(:toastr)
        .with(message[:message], type: message[:type], title: message[:title], options: message[:options])

      helper.toast message[:message],
                   type: message[:type],
                   title: message[:title],
                   options: message[:options]
    end
  end

  describe '#toastr' do
    subject! do
      helper.toastr message[:message],
                    type: message[:type],
                    title: message[:title],
                    options: message[:options]
    end

    it 'renders a toast script' do
      is_expected.to eq "toastr.info('A message', 'A title', { \"some\": options });"
    end

    context 'when a message with a single-quote is given' do
      let(:message) do
        {
          message: "This can't be right!",
          type: :notice,
          title: 'A "title"',
          options: '{ "some": options }'
        }
      end

      it 'replaces the single-quote with "`"' do
        is_expected.to eq "toastr.info('This can`t be right!', 'A \"title\"', { \"some\": options });"
      end
    end
  end
end
