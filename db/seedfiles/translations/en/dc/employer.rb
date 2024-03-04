# frozen_string_literal: true

EMPLOYER_TRANSLATIONS = {
  :'en.employers.plan_years.reference_plan_details' => "Reference Plan Details",
  :'en.employers.plan_years.plan_benefits' => "PLAN BENEFITS",
  :'en.employers.plan_years.co_pay' => "CO-PAY",
  :'en.employers.plan_years.coinsurance' => "COINSURANCE",
  :'en.employers.plan_years.more_details' => "More Details",
  :'en.employers.plan_years.reinstated' => "Reinstated",
  :'en.employers.plan_years.benefits_title' => "Benefits - Coverage You Offer",
  :'en.employers.plan_years.benefits_title_with_draft_py' => "Benefits - Coverage You Offer",
  :'en.employers.plan_years.benefits_without_plan' => "It's time to create a benefits package. Select 'Add Plan Year' to create your first one. Most employers only create one benefits package but you'll have the opportunity to create more than one if you want to offer different benefits to different groups of employees.",
  :'en.employers.plan_years.benefits_with_plan' => "Carefully review the plan information and pricing below. If you haven't added employees to your plan yet, select 'Employees' in the blue menu bar to the left and edit each of your employees to add them to your benefit package. If you want to create more than one benefit package and offer different benefits to different employees, select 'Edit Plan Year' and then select 'Add Benefit Group' at bottom of the page. When you're satisfied with your benefit package(s), select 'Publish Plan Year'.",
  :'en.employers.plan_years.benefits_with_plan.important' => "<strong>IMPORTANT</strong> - Once you select 'Publish Plan Year', your employees will receive a notification and open enrollment will begin according to the timeline you selected for your plan year.",
  :'en.employers.plan_years.oe_tool_tip' => "Employers offering coverage through %{site_short_name} for the first time must have an open enrollment period of no less than 14 days. Employers renewing their %{site_short_name} coverage must have an open enrollment period of at least 30 days.",
  :'en.employers.plan_years.benefit_package.select_your_plan_offering' => "Select Your Plan Offering",
  :'en.employers.plan_years.benefit_package.select_your_plan_offering.content' => "Let your plan participants choose any plan offered by one carrier, any plan available within a specific metal level or you can offer just one plan. It doesn't cost you more to let them choose by carrier (insurance company) or metal level.",
  :'en.employers.plan_years.benefit_package.select_your_reference_plan' => "Select Your Reference Plan",
  :'en.employers.plan_years.benefit_package.select_your_reference_plan.content' => "Now select a reference plan. The reference plan is used to cap employer costs. You’ll choose a reference plan. Then, your contribution towards employee premiums will be applied to the reference plan you choose regardless of which plans your employees select. You can choose a Standard plan which covers many in-network medical services without having to meet the deductible first. After you select your reference plan, scroll down to review your costs.",
  :'en.employers.plan_years.benefit_package.contributions.offered' =>  "You must offer coverage to all eligible full-time employees who work on average, 30 hours a week. Employers can also offer coverage to other employees. While optional, it doesn’t cost you more to offer coverage to your employees' families.",
  :'en.employers.plan_years.benefit_package.contributions.employer_contribution' =>  "Employers are required to contribute at least %{aca_shop_market_employer_contribution_percent_minimum} of the premium costs for employees based on the reference plan selected, except during the special annual enrollment period at the end of each year. Contributions towards family coverage are optional. You can still offer family coverage even if you don’t contribute.",
  :'en.employers.plan_years.benefit_package.employee_cost_button' => "Employee Details Costs",
  :'en.employers.employer_profiles.my_account.important_documents_needed' => "Important Documents Needed",
  :'en.employers.employer_profiles.my_account.eligibility_documents_needed' => "After you complete your application, you will need to submit proof of your eligibility to shop as a small business through the Health Connector. You will need to submit this proof before you are able to shop for a plan. Please review <a href="'https://www.mahealthconnector.org/business/employers/employer-verification-checklist'" target="'_blank'">our list of documents</a> that can be used as proof and make sure that you have the right documentation available.",
  :'en.employers.employer_profiles.my_account.payment_history_description' => "Online and phone payments will appear 2-3 business days after you submit them. Mailed payments will appear within 2 weeks after you mail them. The fastest way to pay is online, by using the button below.",
  :'en.employers.employer_profiles.my_account.pay_your_bill_online' => "Pay Your Bill Online",
  :'en.employers.employer_profiles.my_account.sso_token_success' => "%{site_name}’s on-line payment is powered by Wells Fargo E-Bill Express. By clicking this link, you will be subject to the terms of use found on that website.",
  :'en.employers.employer_profiles.my_account.sso_token_failure' => "We could not connect to the payment provider, please try another method of payment or try again later.",
  :'en.employers.broker_agency_notice.subject' => "You are associated to %{broker_legal_name}- %{agency_legal_name} (Hire)",
  :'en.employers.broker_agency_notice.body' => "<br><p>Associated details<br>General Agency : %{agency_legal_name}<br>Employer : %{employer_legal_name}<br>Status : Hire</p>",
  :'en.employers.registration.kind' => 'Kind *',
  :'en.employers.registration.address' => 'Address *',
  :'en.employers.registration.city' => 'City *',
  :'en.employers.registration.state' => 'State *',
  :'en.employers.registration.zip' => 'Zip *',
  :'en.osse_bqt_eligibility_description' => "Licensed child development centers and homes and their employees are eligible for premium reductions. Eligibility is determined by DC Health Link and the Office of the State Superintendent of Education (OSSE).",
  :'en.osse_eligibility_description' => "Licensed child development centers and homes and their employees are eligible for premium reductions. Eligibility is applied to an initial or renewal plan year when the plan year is created.",
  :'en.osse_ivl_description' => "HealthCare4ChildCare (HC4CC) provides free health insurance for District residents (and their families) who are employees of HC4CC licensed child development centers and homes. Only Admin can confirm HC4CC eligibility for each household member listed below <strong>prior</strong> to submitting a new enrollment.",
  :'en.osse_eligibility_question' => 'Does this business qualify for HC4CC subsidies?',
  :'en.osse_bqt_eligibility_question' => 'Are you creating a quote for a business participating in HC4CC?',
  :'en.osse_eligibility_ivl_question' => 'Does this consumer qualify for HC4CC?',
  :'en.osse_subsidy_title' => 'HealthCare4ChildCare (HC4CC) Program',
  :'en.ivl_osse_subsidy_title_line_1' => 'HealthCare4ChildCare Through DC Health Link:',
  :'en.ivl_osse_subsidy_title_line_2' => 'Affordable health coverage for early childhood providers and their teams',
  :'en.eligibility_history' => 'View eligibility history',
  :'en.osse_eligibility' => 'HC4CC Eligibility',
  :'en.osse_subsidy_title_shortname' => 'HC4CC',
  :'en.audit_log' => 'Audit Log',
  :'en.standard_plan' => 'Standard Plan',
  :'en.osse_subsidy.unable_to_claim' => "Unable to claim HC4CC quote. Please contact customer service at %{contact_center_phone_number}.",
  :'en.quote.not_found' => 'No quote matching this code could be found. Please contact your broker representative.',
  :'en.quote.already_claimed' => 'Quote claim code already claimed.',
  :'en.select_years_osse_offered' => "Select year(s) the HC4CC subsidy is offered.",
  :'en.osse_multi_year_description' => "<strong>Note, </strong>When the eligibility calendar year is set to Active, any coverage year start(initial or renewal) within the active calendar will have HC4CC eligibility.",
  :'en.hc4cc_subsidy_with_pipe' => "HC4CC Subsidies |",
  :'en.select_eligibility_years' => "Select Eligibility Year(s)",
  :'en.employers.employer_profiles.ce_bulk_upload_success_message' => "File uploaded in s3, will process it on the background",
  :'en.employers.employer_profiles.ce_bulk_upload_error_message' => "There was an error on the file upload in S3, please try again"
}.freeze
