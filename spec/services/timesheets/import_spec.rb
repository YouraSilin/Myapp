require 'rails_helper'

RSpec.describe Timesheets::Import do
  describe '#call' do
    subject { described_class.call(file) }
    let(:file) { fixture_file_upload('Табели.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    it 'redirects back after import' do
      expect { subject }.to change { Timesheet.count }.by(444)
        .and change { WorkedHour.count }.by(1776)
    end
  end
end
