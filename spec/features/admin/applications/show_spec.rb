require 'rails_helper'

RSpec.describe "Admin application show page ('/admin/applications/:id')", type: :feature do
  let!(:app_1) { Application.create!(name: "Bob", street_address: "466 Birch Road", city: "Birmingham", state: "Alabama", zip_code: "35057", description: "description", status: "Pending" ) }
  let!(:app_2) { Application.create!(name: "Tina Belcher", street_address: "466 Albion Street", city: "New York", state: "New York", zip_code: "10001", description: "We have lots of fun", status: "Pending" ) }
  let!(:app_3) { Application.create!(name: "Lisa Belcher", street_address: "466 Mexico Ave", city: "New York", state: "New York", zip_code: "10001", description: "We have lots of fun", status: "Pending" ) }
  let!(:shelter1) { Shelter.create!(name:"Paws without Laws", foster_program: false, city: "Denver", rank: 3) }
  let!(:pet_1) { shelter1.pets.create!(name: "Matt", age: 14, breed: "Cat", adoptable: true) }
  let!(:pet_2) { shelter1.pets.create!(name: "Pog", age: 14, breed: "Dog", adoptable: true) }
  let!(:pet_3) { shelter1.pets.create!(name: "Anetra", age: 3, breed: "Leopard Gecko", adoptable: true) }
  let!(:pet_4) { shelter1.pets.create!(name: "Alaska", age: 6, breed: "Cat", adoptable: true) }
  let!(:pet_app_1) { PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id) } 
  let!(:pet_app_2) { PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id) } 
  let!(:pet_app_3) { PetApplication.create!(pet_id: pet_3.id, application_id: app_2.id) } 
  let!(:pet_app_4) { PetApplication.create!(pet_id: pet_3.id, application_id: app_3.id) } 
  
  before :each do
    visit "/admin/applications/#{app_1.id}"
  end

  context "Approving a pet" do
    it 'has a a button to approve the application for each pet' do
      expect(page).to have_button("Approve")
      expect(page).to have_css("#approve-#{pet_1.id}")
      expect(page).to have_css("#approve-#{pet_2.id}")

      expect(page).to_not have_content(pet_3.name)
      expect(page).to_not have_content(pet_4.name)
    end

    it "redirects to the admin show page, after being clicked" do
      find("#approve-#{pet_1.id}").click

      expect(current_path).to eq("/admin/applications/#{app_1.id}")
    end

    it "shows no approval button after being clicked" do
      find("#approve-#{pet_1.id}").click

      expect(page).to_not have_css("#approve-#{pet_1.id}")
      expect(page).to have_css("#approve-#{pet_2.id}")
    end

    it "shows a message that the pet has been approved" do
      find("#approve-#{pet_1.id}").click

      expect(page).to have_content("Approved!")
      expect(pet_1.name).to appear_before("Approved!")
      expect("Approved!").to appear_before(pet_2.name)
    end
  end

  context "Rejecting a pet" do
    it 'has a a button to Reject the application for each pet' do
      expect(page).to have_button("Reject")
      expect(page).to have_css("#reject-#{pet_1.id}")
      expect(page).to have_css("#reject-#{pet_2.id}")

      expect(page).to_not have_content(pet_3.name)
      expect(page).to_not have_content(pet_4.name)
    end

    it "redirects to the admin show page, after being clicked" do
      find("#reject-#{pet_1.id}").click

      expect(current_path).to eq("/admin/applications/#{app_1.id}")
    end

    it "shows no approval button after being clicked" do
      find("#reject-#{pet_1.id}").click

      expect(page).to_not have_css("#reject-#{pet_1.id}")
      expect(page).to have_css("#reject-#{pet_2.id}")
    end

    it "shows a message that the pet has been Rejectd" do
      find("#reject-#{pet_1.id}").click

      expect(page).to have_content("Rejected")
      expect(pet_1.name).to appear_before("Rejected")
      expect("Rejected").to appear_before(pet_2.name)
    end
  end

    
  it "has button to approve/reject the same pet after approval/rejection" do
    visit "/admin/applications/#{app_2.id}"
    find("#approve-#{pet_3.id}").click
    visit "/admin/applications/#{app_3.id}"
    expect(page).to have_button("Approve")
    expect(page).to have_button("Reject")
  end
end