require 'rails_helper'

RSpec.shared_examples 'breadcrumbable' do
  authenticate :admin

  describe '#add_breadcrumb' do
    let(:params) { build :user, id: 1 }

    subject { controller.add_breadcrumb(params).last }

    context 'when the argument is a model instance' do
      before { expect(controller).to receive(:url_for).and_return 'admin/users/1' }

      it "renders a linked breadcrumb to the model's show action" do
        is_expected.to include 'User #1', 'admin/users/1'
      end
    end

    context 'when the argument is a model class' do
      let(:params) { User }

      before { expect(controller).to receive(:url_for).and_return 'admin/users' }

      it "renders a linked breadcrumb to the model's index" do
        is_expected.to include 'Users', 'admin/users'
      end
    end

    context 'when the argument is not a model class nor instance' do
      let(:params) { 'Pure awesomeness!' }

      it 'renders a text breadcrumb with the given argument' do
        is_expected.to eq params
      end
    end
  end
end
