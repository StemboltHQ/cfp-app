require 'rails_helper'

def select_demographics(args)
  select(args[:country], from: 'person[country]')
end

feature 'User Profile' do
  let(:user) { create(:person) }

  before { login_user(user) }


  scenario "A user can save demographics info" do
    visit(edit_profile_path)
    select_demographics(country: 'Albania')
    click_button 'Save'

    expect(user.demographics['country']).to eq("Albania")
  end

  scenario "A user can change their demographic info" do
    visit(edit_profile_path)
    select_demographics(country: 'Albania')
    click_button 'Save'

    visit(edit_profile_path)
    select_demographics(country: 'Algeria')
    click_button 'Save'

    expect(user.demographics['country']).to eq('Algeria')
  end

  scenario "A user can save their bio" do
    visit(edit_profile_path)
    fill_in('Bio', with: 'I am awesome')
    click_button 'Save'

    expect(user.bio).to eq('I am awesome')
  end

  scenario "A user can edit their bio" do
    visit(edit_profile_path)
    fill_in('Bio', with: 'I am awesome')
    click_button 'Save'

    visit(edit_profile_path)
    fill_in('Bio', with: 'I am even more awesome')
    click_button 'Save'

    expect(user.bio).to eq('I am even more awesome')
  end

  scenario "A user attempts to save their bio without email" do
    visit (edit_profile_path)
    fill_in('Email', with: '')
    click_button 'Save'
    expect(page).to have_content("Unable to save profile. Please correct the following: Email can't be blank")
  end
end
