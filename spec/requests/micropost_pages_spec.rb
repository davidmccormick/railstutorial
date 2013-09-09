require 'spec_helper'

describe "Micropost pages" do
	
	subject { page }
	
	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }
	
	describe "micropost creation" do
		before { visit root_path }
		
		context "with invalid information" do
			it "should not create an empty micropost" do
				expect { click_button "Post" }.to_not change(Micropost, :count)
			end
			
			describe "error message" do
				before  { click_button "Post" }
				
				it "should render an error message" do
					expect(page).to have_content('error')
				end
			end
		end
		
		context "with valid post" do
			before { fill_in 'micropost_content', with: "Lorem Ipsum" }
			it "creates the micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end
end
