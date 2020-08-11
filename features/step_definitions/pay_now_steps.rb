# frozen_string_literal: false

Given(/^that a person exists in EA$/) do
  visit "/"
  click_link 'Consumer/Family Portal'
  FactoryBot.create(:hbx_profile, :open_enrollment_coverage_period)
  FactoryBot.create(:qualifying_life_event_kind, market_kind: "individual")
  FactoryBot.create(:qualifying_life_event_kind, :effective_on_event_date_and_first_month, market_kind: "individual")
  BenefitMarkets::Products::ProductRateCache.initialize_rate_cache!
  screenshot("individual_start")
  sleep 10
  fill_in "user[oim_id]", :with => "testflow@test.com"
  fill_in "user[password]", :with => "aA1!aA1!aA1!"
  fill_in "user[password_confirmation]", :with => "aA1!aA1!aA1!"
  screenshot("create_account")
  click_button "Create Account"
  expect(page).to have_content("Your Information")
  expect(page).to have_content("CONTINUE")
  click_link "CONTINUE"
  sleep 5
end

Given(/^Hbx Admin creates a consumer application$/) do
  visit exchanges_hbx_profiles_root_path
  find('.interaction-click-control-families', wait: 10).click
  page.find('.interaction-click-control-new-consumer-application', wait: 10).click
  visit begin_consumer_enrollment_exchanges_agents_path
  fill_in "person_first_name", with: "John"
  fill_in "person_last_name", with: "Smith"
  fill_in "jq_datepicker_ignore_person_dob", with: "11/11/1991"
  fill_in "person_ssn", with: '212-31-3131'
  find(:xpath, '//label[@for="radio_male"]', wait: 10).click
  find('.btn', text: 'CONTINUE', wait: 10).click
  expect(page).to have_content('Thank you. Next, we need to verify if you or you and your family are eligible to enroll in coverage through DC Health Link. Please select CONTINUE.')
  find('.interaction-click-control-continue', wait: 10).click
  find(:xpath, "//*[@id='new_person_wrapper']/div/div[1]/div[1]/div[2]/div/div[2]", wait: 10).click
  find("li", :text => "Paper").click
  find(:xpath, '//label[@for="person_us_citizen_true"]', wait: 10).click
  find(:xpath, '//label[@for="person_naturalized_citizen_false"]', wait: 10).click
  find(:xpath, '//label[@for="indian_tribe_member_no"]', wait: 10).click
  find(:xpath, '//label[@for="radio_incarcerated_no"]', wait: 10).click
  fill_in "person_addresses_attributes_0_address_1", with: "123 Main St"
  fill_in "person_addresses_attributes_0_address_2", with: "apt 1005"
  fill_in "person_addresses_attributes_0_city", with: "Washington"
  find(:xpath, "//span[@class='label'][contains(., 'SELECT STATE')]", wait: 10).click
  find(:xpath, '//*[@id="address_info"]/div/div[3]/div[2]/div/div[3]/div/ul/li[10]', wait: 10).click
  fill_in "person[addresses_attributes][0][zip]", with: "35465"
  find('.btn', text: 'CONTINUE', wait: 10).click
end

And(/^the person has an active consumer role$/) do
  fill_in "person_first_name", with: "John"
  fill_in "person_last_name", with: "Smith"
  fill_in "jq_datepicker_ignore_person_dob", with: "11/11/1991"
  fill_in "person_ssn", with: '212-31-3131'
  find(:xpath, '//label[@for="radio_male"]').click
  find(:xpath, '//label[@for="is_applying_coverage_true"]').click
  screenshot("register")
  find('.btn', text: 'CONTINUE').click
  find('.interaction-click-control-continue', text: 'CONTINUE', :wait => 10).click
end

And(/^the person has an active resident role$/) do
  fill_in "person_first_name", with: "John"
  fill_in "person_last_name", with: "Smith"
  fill_in "jq_datepicker_ignore_person_dob", with: "11/11/1991"
  find('.interaction-choice-control-value-person-no-ssn').click
  find(:xpath, '//label[@for="radio_male"]').click
  find(:xpath, '//label[@for="is_applying_coverage_true"]').click
  screenshot("register")
  find('.btn', text: 'CONTINUE').click
  find('.interaction-click-control-continue', text: 'CONTINUE', :wait => 10).click
end

And(/^the person goes plan shopping in the individual for a new plan$/) do
  wait_for_ajax
  expect(page).to have_button("CONTINUE", visible: false)
  find('.btn', text: 'CONTINUE').click
  click_link "Continue"
  expect(page).to have_content('Verify Identity')
  find(:xpath, '//label[@for="interactive_verification_questions_attributes_0_response_id_a"]', wait: 5).click
  find(:xpath, '//label[@for="interactive_verification_questions_attributes_1_response_id_c"]', wait: 5).click
  screenshot("identify_verification")
  click_button "Submit"
  screenshot("override")
  click_link "Continue Application"
end

When(/^the person enrolls in a Kaiser plan$/) do
  screenshot("line 161")
  click_link 'Continue', :wait => 10
  click_link "Married"
  expect(page).to have_content "Married"
  screenshot("past_qle_date")
  fill_in "qle_date", :with => (TimeKeeper.date_of_record - 5.days).strftime("%m/%d/%Y")
  find('h1').click
  within '#qle-date-chose' do
    click_link "CONTINUE"
  end
  expect(page).to have_content "Based on the information you entered, you may be eligible to enroll now but there is limited time"
  screenshot("valid_qle")
  click_button "Continue"
  expect(page).to have_content "Choose Coverage for your Household"
  click_button "CONTINUE"
  screenshot("plan_shopping")
  find_all('.plan-select')[0].click
end

And(/I click on purchase confirm button for matched person/) do
  find('.interaction-choice-control-value-terms-check-thank-you').click
  fill_in 'first_name_thank_you', with: "John"
  fill_in 'last_name_thank_you', with: "Smith"
  screenshot("purchase")
  click_link "Confirm"
end

Then(/I should click on pay now button/) do
  find('.interaction-click-control-pay-now').click
end

And(/I should see model pop up/) do
  expect(page).to have_css('.modal-open')
end

And(/I should see Leave DC LINK buttton/) do
  expect(page).to have_content('Leave DC LINK')
end

And(/I should be able to click  Leave DC LINK buttton/) do
  find('.interaction-click-control-leave-dc-link').click
  sleep 5
end