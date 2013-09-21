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
				expect(page).to have_selector("div.alert.alert-success", text: "Micropost Created")
			end
		end
	end
	
	describe "micropost destruction" do
		let!(:post) { FactoryGirl.create(:micropost, user: user) }
		let(:wrong_user) { FactoryGirl.create(:user) }	
		
		context "as the correct user"  do
			before { visit root_path }
		
			it "should delete a micropost" do
				expect { click_link  "delete" }.to change(Micropost, :count).by(-1)
			end
		end
		
		context "as the wrong user" do
			before { 
				sign_in wrong_user
				delete micropost_path(post)
				# Note this is rack test - not capybara!!
			}
			it "should redirect to the root path" do
				expect(response).to redirect_to(root_path)
			end
			it "should have an error flash" do
				follow_redirect!
				expect(response.body).to have_content("You are not allowed to destroy microposts that you do not own!")
			end
		end
	end
end
