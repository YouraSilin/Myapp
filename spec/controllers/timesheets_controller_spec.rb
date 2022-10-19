require 'rails_helper'

RSpec.describe TimesheetsController, type: :controller do
  describe 'POST /timesheets/import' do
    subject { post :import, params: { file: file } }
    let(:file) { fixture_file_upload('Табели.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

    it 'redirects back after import' do
      expect(Timesheets::Import).to receive(:call)

      subject

      expect(response).to redirect_to(timesheets_path)
    end
  end
end
