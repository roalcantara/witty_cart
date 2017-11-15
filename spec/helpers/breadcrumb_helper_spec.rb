require 'rails_helper'

RSpec.describe BreadcrumbHelper do
  describe '#breadcrumb' do
    let(:last) { nil }
    let(:bread) { 'Sasuke!' }

    subject! { helper.breadcrumb bread, last: last }

    context 'when a string is given' do
      it 'returns the given string' do
        is_expected.to eq bread
      end
    end

    context 'when an array is given' do
      let(:bread) { ['Sasuke!', { controller: 'admin/users', action: :show, id: 1 }] }

      context 'when it is NOT the last item' do
        let(:last) { false }

        it 'builds and returns a link to the given parameters' do
          is_expected.to include 'admin/users/1'
        end
      end

      context 'when it is the last item' do
        let(:last) { true }

        it 'returns the 1st element of the array' do
          is_expected.to eq bread[0]
        end

        it 'does not return a link built with given parameters' do
          is_expected.to_not include 'admin/users/1'
        end
      end
    end
  end
end
