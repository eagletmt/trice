require 'spec_helper'
require 'trice_controller_method_test_controller'

describe TriceControllerMethodTestController, type: :controller do
  describe '#requested_at should be same time' do
    before do
      get :hi
    end

    specify { expect(assigns(:requested_at_x)).to be_acts_like(:time) }
    specify { expect(assigns(:requested_at_x)).to be assigns(:requested_at_y) }
  end

  describe 'request stubbing' do
    let(:time) { Time.zone.parse('2016-02-01 00:00:00') }

    context 'stubbed by query' do
      before do
        get :hi, '_requested_at' => time.strftime('%Y%m%d%H%M%S')
      end

      specify { expect(assigns(:requested_at_x)).to eq time }
    end

    context 'stubbed by header' do
      before do
        request.headers['X-Requested-At'] = time.iso8601
        get :hi
      end

      specify { expect(assigns(:requested_at_x)).to eq time }
    end

    context 'stubbed by both' do
      let(:time) { Time.zone.parse('2016-02-01 00:00:00') }

      before do
        request.headers['X-Requested-At'] = 1.day.ago(time).iso8601

        get :hi, '_requested_at' => time.strftime('%Y%m%d%H%M%S')
      end

      specify 'prefers query params' do
        expect(assigns(:requested_at_x)).to eq time
      end
    end
  end
end
