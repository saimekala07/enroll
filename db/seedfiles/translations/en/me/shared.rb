SHARED_TRANSLATIONS = {
    "en.address_line_1" => "ADDRESS LINE 1",
    "en.address_line_2" => "ADDRESS LINE 2",
    "en.city" => "CITY",
    "en.zip" => "ZIP",
    "en.new_address_shared" => "NEW ADDRESS",
    "en.home_address_shared" => "Home Address",

    "en.support_texts.new_address_shared" => "NEW ADDRESS",
    "en.support_texts.home_address_shared" => "Home Address",
    "en.support_texts.is_applying_coverage" => "<b> Does this person need coverage? </b> <br> <br> If you need coverage, select ‘yes’. If you’re applying for coverage for someone else, but don’t need coverage for yourself, select ‘no’. If you don’t need or qualify for coverage, but someone in your family or that you include on your tax return does, you can apply on their behalf.",
    "en.support_texts.us_citizen" => "<b> Is this person a US citizen or US national? </b> <br> <br> You’re a US citizen if you were born in the US or certain US territories, had a parent who was a US citizen when you were born, or you became a US citizen through adoption or naturalization.<br> <br> A US national is a US citizen or anyone who owes permanent allegiance to the US.",
    "en.support_texts.naturalized_citizen" => "<b> Is this person a naturalized citizen? </b> <br> <br> A naturalized citizen is someone who wasn’t born a US citizen. A person can apply to be a naturalized citizen after being a permanent resident (green card holder) for a certain period of time, and if they meet certain other legal requirements.",
    "en.support_texts.eligible_immigration_status" => "<b>Does this person have an eligible immigration status? </b> <br> <br> Anyone with an eligible immigration status may qualify to get health insurance coverage through <%= EnrollRegistry[:enroll_app].setting(:short_name).item %>. There are many eligible categories. Some common types include but aren’t limited to: <br> <ul> <li>Lawful permanent resident (LPR/green card holder)</li><li>Asylee or applicant for asylum who has an approved employment authorization</li><li>Refugee</li><li>Individuals with non-immigrant status, such as those who have:</li><ul><li>Worker visas</li><li>Student visas</li></ul><li>Temporary Protected Status (TPS) or applicants for TPS with an approved employment authorization</li><li>Victim of trafficking and his or her spouse, child, sibling, or parent, and applicants for a victim of trafficking visa</li></ul>If you don’t see your status on this list, <a href='<%= EnrollRegistry[:enroll_app].setting(:eligibile_immigration_statuses_url).item %>' target='_blank'> view the full list of eligible immigration statuses</a> to see if you may qualify to get coverage through <%= EnrollRegistry[:enroll_app].setting(:short_name).item %>.",
    "en.support_texts.is_incarcerated" => "<b>Is this person currently incarcerated? </b> <br> <br> Select 'yes' if any of the following situations apply: <br> <ul> <li> You're serving a term in prison or jail </li> <li> You're currently staying in a halfway house </li> </ul> <br> Select 'no' if: <ul> <li> You're on probation, parole, or home confinement </li> <li> You're being held in jail or prison, but haven't been convicted of a crime <br> (in other words, charges are pending)",
    "en.support_texts.is_physically_disabled" => "<b>Does this person have a disability? </b> <br> <br> A person is considered disabled if they have one or more of these conditions: <br> <ul> <li>Blind, deaf, or hard of hearing</li><li>Receives Social Security Disability Insurance (SSDI) or Supplemental Security Insurance (SSI)</li><li>Has a physical, cognitive, intellectual, or mental health condition, which causes one or more of the following:</li><ul><li>Difficulty doing errands like visiting a doctor’s office or shopping</li><li>Serious difficulty concentrating, remembering, or making decisions</li><li>Difficulty walking or climbing stairs</li></ul></ul>In addition to the above, the following conditions are also considered disabilities for children:<ul><li>Limited ability to do the things most children of the same age can do</li><li>Need or use more health care than is usual for most children of the same age</li><li>Receives special education services or services under a Section 504 plan</li><ul>",

    # help coverage
    "en.support_texts.is_applying_for_assistance" => "<b> Do you want to apply for monthly premium reductions and lower out-of-pocket costs? </b> <br> <br> If you answer 'yes', we’ll check to see if you qualify for monthly premium reductions, out-of-pocket cost-sharing reductions, and Medicaid. If you answer 'no', you’ll have to pay full price for private health insurance. <br> <ul> <li>Monthly premium reductions and cost-sharing reductions lower your costs for private health insurance</li><li>Medicaid offers free coverage</li></ul> Federal law does not allow you to  apply for just one program.<br><br> Before applying, in less than a minute you can get an estimate of what you might qualify for using our <a href='<%= EnrollRegistry[:enroll_app].setting(:assistance_estimate_url).item %>' target='_blank'>Plan Match</a> tool.",

    #financial assistance support text
    "en.has_job_income" => "<b>Does this person have income from an employer? </b> <br> <br> Select ‘yes’ if this person is considered an employee of a business, or receives a W-2 federal form from any employer. We need to know about all income this person receives from an employer, including wages, tips, salaries, and bonuses. <br><br> If this income varies, you may want to estimate it for a longer period of time (for example, monthly or annually instead of weekly). <br><br> We only need an exact start date if this income began this year. If it began in a prior year and you don’t remember the exact start date, you can enter the first day of the current year as the start date. <br><br> Only enter an end date for income in the “To” field if this income has ended or is expected to end on a certain date. Otherwise leave this field blank.",
    "en.has_self_employment_income" => "<b>Is this person self-employed? </b> <br> <br> Select 'yes' if this person owns a business or receives a federal form 1099 from any employer. We need to know about any income this person receives as an independent contractor or from a business they own.",
    "en.has_unemployment_income" => "<b>Did this person receive unemployment income at any point in %{application_applicable_year}? </b> <br> <br> Select ‘yes’ if this person received one or more types of unemployment income listed below at any point in %{application_applicable_year}, even if they no longer receive this income. <br> <ul> <li> Regular unemployment compensation </li> <li> Pandemic Emergency Unemployment Compensation (PEUC) </li> <li> Extended unemployment compensation </li><li> Pandemic Unemployment Assistance (PUA) </li></ul> <br> We need to know about any unemployment income this person received in %{application_applicable_year} to check if they qualify for lower monthly premiums under the <a href='https://www.dchealthlink.com/coronavirus/americanrescueplan' target='_blank'>American Rescue Plan</a>.",
    "en.has_american_indian_alaskan_native_income" => "<b>Is any of this person's income from American Indian or Alaska Native tribal sources? </b> <br> <br> We need to know about any of the income you've told us about that is from any of the following sources: <br> <ul> <li> Per capita payments from the tribe that come from natural resources, usage rights, leases or royalties. </li> <li> Payments from natural resources, farming, ranching, fishing, leases, or royalties from land designated as Indian land by the Development of Interior (including reservations and former reservations). </li> <li> Money from selling things that have cultural significance. </li>",
    "en.has_other_income" => "<b>Does this person expect to have income from other sources in %{application_applicable_year}? </b> <br> <br> Select ‘yes’ if this person receives one or more types of taxable income listed below, even if that income is infrequent, or they only receive it for part of the year. <br> <ul> <li> Alimony received </li> <li> Capital gains </li> <li> Dividends </li><li> Interest </li><li> Rent and royalties </li><li> Pension or retirement, including IRA distributions </li><li> Social Security </li><li> Unemployment </li><li> Foreign income </li><li> Other taxable income </li><li> Gambling, prizes or awards </li><li> Scholarships </li><li> Strike or lockout benefits </li><li> Any other taxable income included on your federal tax return </li></ul>",
    "en.has_deductions" => "<b>Does this person expect to have income adjustments in %{application_applicable_year}? </b> <br> <br> Select 'yes' if this person expects to have any of the types of expenses listed below for the year you’re applying for coverage. Income adjustments are certain types of expenses you can claim on your federal tax return that lower the amount of taxable income. <br> <ul> <li>Alimony paid</li><li>Certain business expenses of reservists, performing artists, and fee-basis government officials</li><li>Deductible part of the self-employment tax</li><li>Domestic production activities deduction</li><li>Educator expenses</li><li>Health savings account deduction</li><li>IRA deduction</li><li>Moving expenses</li><li>Penalty on early withdrawal of savings</li><li>Self-employed health insurance deduction</li><li>Self-employed SEP, SIMPLE and qualified plans</li><li>Student loan interest deduction</li><li>Tuition and fees</li> </ul>",
    "en.has_enrolled_health_coverage" => "<b>Is this person currently enrolled in health coverage? </b> <br> <br> If this person is currently enrolled in one of the following types of coverage, select ‘yes’, even if it will end soon. Only answer ‘yes’ if this person has one of the types of coverage listed below. <br> <ul> <li>Employer-sponsored health coverage</li><li>Continuation coverage from a former employer (COBRA)</li><li>Coverage purchased on the individual market</li><li>Medicaid or CHIP (Children’s Health Insurance Program)</li><li>Medicare</li><li>Tricare</li><li>VA</li><li>Peace Corps</li></ul>",
    "en.has_eligible_health_coverage" => "<b>Does this person currently have access to other health coverage, including through another person? </b> <br> <br> Select ‘yes’ if this person could get any of the types of health coverage listed below, either directly, or through another person such as a spouse or parent. If any of the types of health coverage listed below were available to this person, but they chose not to enroll, you should answer ‘yes’.  <br> <ul> <li>Employer-sponsored health coverage</li><li>Continuation coverage from a former employer (COBRA)</li><li>Coverage purchased on the individual market</li><li>Medicaid or CHIP (Children’s Health Insurance Program)</li><li>Medicare</li><li>Tricare</li><li>VA</li><li>Peace Corps</li></ul>",
    "en.has_enrolled_health_coverage_from_hra" =>"<b>Is this person currently enrolled in health coverage or getting help paying for health coverage through a Health Reimbursement Arrangement? </b> <br> <br>If this person is currently enrolled in one or more of the types of health coverage listed below, select ‘yes’. You don’t need to tell us about health coverage that will end in the next 60 days. <br><ul><li>Marketplace plan</li><li>MaineCare (Medicaid)</li><li>CubCare (Children’s Health Insurance Program)</li><li>Medicare</li><li>TRICARE</li><li>Coverage through a job (or another person's job, like a spouse or parent)</li><li>Health Reimbursement Arrangement (Individual Coverage HRA or Qualified Small Employer HRA)</li><li>COBRA</li><li>Retiree Health Benefits</li><li>Veterans Affairs (VA) Health Care Program</li><li>Peace Corps health benefits</li><li>Other full benefit coverage</li><li>Other limited benefit coverage</li></ul><p>A Health Reimbursement Arrangement (HRA) is a type of group health plan that lets an employer reimburse a person for qualifying medical expenses, including their monthly health plan premium, in some cases. We need to know about any HRA that covers health insurance premiums that you have or could get from an employer.</p>",
    "en.has_eligible_health_coverage_from_hra" => "<b>Does this person currently have access to health coverage or a Health Reimbursement arrangement that they are not enrolled in (including through another person, like a spouse or parent)?</b> <br> <br> Select ‘yes’ if this person could get any of the types of health coverage listed below, either directly, or through another person such as a spouse or parent. If any of the types of health coverage listed below were available to this person, but they chose not to enroll, you should answer ‘yes’. <br> <ul> <li>Marketplace plan</li><li>MaineCare (Medicaid)</li><li>CubCare (Children’s Health Insurance Program)</li><li>Medicare</li><li>TRICARE</li><li>Coverage through a job (or another person's job, like a spouse or parent)</li><li>Health Reimbursement Arrangement (Individual Coverage HRA or Qualified Small Employer HRA)</li><li>COBRA</li><li>Retiree Health Benefits</li><li>Veterans Affairs (VA) Health Care Program</li><li>Peace Corps health benefits</li><li>Other full benefit coverage</li><li>Other limited benefit coverage</li></ul><p>A Health Reimbursement Arrangement is a type of group health plan that lets an employer reimburse a person for qualifying medical expenses, including their monthly health plan premium, in some cases. We need to know about any HRA that covers health insurance premiums that you have or could get from an employer.</p><p>To 'accept' an HRA offer, a person must tell the employer that they plan to use the HRA. If an HRA is available through an employer, but a person hasn't yet told the employer that they want to sign up for it, they aren't considered to be enrolled in an HRA. In some cases, a person may be able to change their mind about enrolling in an HRA they've signed up for, but hasn't started yet. If interested, ask the employer if this is an option.</p>",
    "en.hra_benefit" => "<b>What's the maximum self-only amount of reimbursement offered by this employer?</b> <br> <br>Employers that offer individual coverage HRAs must send written notices that include the maximum self-only reimbursement amount. If you have questions about the HRA, like what this amount is, look at the employer's HRA notice or check with the employer.",
    "en.support_texts.net_annual_income" => "<b>Annual Income for %{application_applicable_year}</b><br><br> This is the total of all income you told us about for this person minus any income adjustments for %{application_applicable_year}. If you think this amount is incorrect, select the pencil icon to go back to the application and make changes. If a certain type of income varies, you may want to estimate it for a longer period of time (for example, monthly or annually instead of weekly).",
    "en.support_texts.relationship" => "<b>Relationship types</b><br><br> Select the option that best describes the family relationship. <ul><li>'Child' includes biological, adoptive, step, and foster children</li><li>'Parent' includes biological, adoptive, step, and foster parents</li><li>'Sibling' includes biological, half, adoptive, step, and foster siblings</li></ul><br> If these people are related but the type of relationship isn't on this list (for example, if you are cousins), select 'Unrelated'.",

    # Tax Info
    "en.support_texts.is_required_to_file_taxes" => "<b>Will this person file taxes for %{application_applicable_year}? </b> <br> <br> Answer ‘yes’ if you plan to file federal taxes for the year you’ll have health coverage, even if you haven’t filed in the past. Answer ‘no’ if you don’t. We need to know about your tax filing plans, because if you qualify for monthly premium reductions to help pay for private health insurance, you must file taxes for the year you have coverage.",
    "en.support_texts.is_joint_tax_filing" => "<b>Will this person be filing jointly? </b> <br> <br> If you’re married and file your federal taxes jointly, select ‘yes’. If you don’t plan to file taxes, or plan to file with any other status, select ‘no’.",
    "en.support_texts.is_filing_as_head_of_household" => "<b>Will this person be filing as Head of Household?</b><br><br>Head of Household is a tax filing status with specific requirements. If you are married, you only qualify to file as head of household if all of the following apply:<br><br><ul><li>You will live apart from your spouse for at least the last 6 months of the year</li><li>You will file a tax return separately from your spouse</li><li>You will pay at least half the cost of keeping up the home for yourself and a qualifying dependent</li></ul><br>Learn more about filing as Head of Household ( https://www.irs.gov/help/ita/what-is-my-filing-status )",
    "en.support_texts.is_claimed_as_tax_dependent" => "<b>Will this person be claimed as a tax dependent for %{application_applicable_year}? </b> <br> <br> We need to know if this person will be claimed by anyone as a tax dependent, to see if they qualify for monthly premium reductions, lower out-of-pocket costs, or Medicaid. We need to know who plans to claim this person as a tax dependent for the year they get coverage, even if that person has not claimed them as a dependent in the past.<br> The person who claims a tax dependent is responsible for making sure the dependent has health insurance.",
    "en.support_texts.claimed_as_tax_dependent_by" => "<b>Who will claim this person as a dependent? </b> <br> <br> This list shows all the tax filers you’ve listed on the application so far. If you haven’t added the tax filer who plans to claim this person to the application yet, you can come back and answer this question after you have added that person. <br> You must tell us about about everyone listed on the tax return of someone who claims an applicant as a dependent to determine whether the dependent qualifies for monthly premium reductions, lower out-of-pocket costs, or Medicaid.",

    # Other Questions
    "en.is_pregnant" => "<b>Is this person pregnant? </b> <br> <br> We ask this question because people who are pregnant, and meet certain income limits, may qualify for free, comprehensive Medicaid coverage.",
    "en.is_self_assisted_blind" => "<b>Is this person blind? </b> <br> <br> We ask this question because people who are blind, and meet certain income limits, may qualify for free, comprehensive Medicaid coverage.",
    "en.has_daily_living_help" => "<b> Does this person need help with activities of daily living, such as dressing or bathing? </b> <br> <br> Activities of daily living include basic functions that most people do without help every day, like eating, dressing, bathing, going to the bathroom, continence and transferring. Transferring includes activities like walking, or getting in and out of a bed, chair or wheelchair. People who need help with activities of daily living, and also meet certain income limits, may qualify for additional services under Medicaid.",
    "en.need_help_paying_bills" => "<b> Does this person need any help paying for medical bills from the last 3 months? </b> <br> <br> If this person qualifies for Medicaid, they may be able to get help paying medical bills from the last 3 months. Medicaid can pay bills for Medicaid covered services, if the provider this person got the service from accepts Medicaid, and the bill hasn’t been paid yet. Bills will only be paid if this person would have qualified for Medicaid during that time.",
    "en.primary_caretaker_question" => "<b>Is this person the main person taking care of any children age 18 or younger who live with them? </b> <br> Select 'yes' if this person is the main person taking care of a child who lives with them who is either: <br> * Under age 18 <br> * 18 and a full-time student <br> Both married spouses can be main caretakers to children living at home, even if they're in childcare or cared for by others most days.",

    # help coverage
    "en.is_applying_for_assistance" => "<b> Do you want to apply for monthly premium reductions and lower out-of-pocket costs? </b> <br> <br> If you answer 'yes', we’ll check to see if you qualify for monthly premium reductions, out-of-pocket cost-sharing reductions, and Medicaid. If you answer 'no', you’ll have to pay full price for private health insurance. <br> <ul> <li>Monthly premium reductions and cost-sharing reductions lower your costs for private health insurance</li><li>Medicaid offers free coverage</li></ul> Federal law does not allow you to  apply for just one program.<br><br> Before applying, in less than a minute you can get an estimate of what you might qualify for using our <a href='https://dc.checkbookhealth.org/hie/dc/2021/index.cfm?page' target='_blank'>Plan Match</a> tool.",

    # health coverage
    "en.is_esi_waiting_period" => "<b> Is this person in a waiting period and eligible to enroll in the next 3 months? </b> <br> <br> Select ‘yes’ if this person can get health coverage within the next 3 months after a waiting period. Some employers that offer health insurance have a waiting period of a few months before health insurance starts.",
    "en.is_esi_mec_met" => "<b> Does this employer offer a health plan that meets the minimum value standard? </b> <br> <br> The minimum value is a standard used to see if a health plan offered by your employer meets the basic requirements of the Affordable Care Act. Most health plans offered by employers meet this standard. You can find out of the plan offered by your employer meets this standard by: <br> <ul> <li>Having your employer or benefits department fill out the <a href='https://www.dchealthlink.com/sites/default/files/v2/forms/Employer%20Coverage%20Tool.pdf' class='benefit-support-modal' target='_blank'>Employer Coverage Tool </a> </li><li>Checking the Summary of Benefits and Coverage for your employer’s plan.</li></ul>",
    "en.employee_cost" => "<b> How much would the employee pay for the lowest cost plan that would meet the minimum value standard? </b> <br> <br> We ask this question to see if coverage available to this person through their job is considered affordable by federal government standards. Use the <a href='https://www.dchealthlink.com/sites/default/files/v2/forms/Employer%20Coverage%20Tool.pdf' class='benefit-support-modal' target='_blank'>Employer Coverage Tool </a> to get the right answer for this question. Remember to include only the premium amount for the employee-only plan &mdash; not for a plan that covers more than one person.",
    "en.help_me_decide" => "<b>Who else should I include in my household? </b> <br> <br> Include the following people (even if they do not live with you, or don’t need coverage):<br> <ul> <li>Your spouse, if you’re legally married</li><li>Anyone you will claim as a tax dependent </li></ul> You’ll need to list additional people if any of the following exceptions apply: <br> <ul> <li><b> You want to cover a child under 26 who you do not claim as a tax dependent: </b>Include the child you want to cover, and anyone else included on your child’s tax return.</li> <li><b>You live with and care for a child under 21 who you do not claim as a dependent: </b>Include any of the child’s parents and siblings who live with you. Include the person who claims this child as a tax dependent, and anyone else that person lists on their tax return (their spouse and other dependents).</li> <li> <b>You don’t plan to file a tax return:</b> Include your spouse (if you are legally married and live together), your children under age 21 who live with you, and your child’s parent (if they live with you).</li> </ul> You do not need to include: <ul> <li> Your roommates (unless they’re a spouse or tax dependent)</li> <li> Your unmarried domestic partner (unless you claim this person as your tax dependent or have a child in common who lives with you)</li> <li> Your spouse if you’re legally separated, divorced, or are a victim of domestic abuse, domestic violence, or spousal abandonment</li> </ul> ",

    # income adjustments
    "en.is_physically_disabled" => "<b>Does this person have a disability?</b><br /><br /><p>A person is considered disabled if they have one or more of these conditions:<br /><ul><li>Blind, deaf, or hard of hearing</li><li>Receives Social Security Disability Insurance (SSDI) or Supplemental Security Insurance (SSI)</li><li>Has a physical, cognitive, intellectual, or mental health condition, which causes one or more of the following:<ul><li>Difficulty doing errands like visiting a doctor's office or shopping</li><li>Serious difficulty concentrating, remembering, or making decisions</li><li>Difficulty walking or climbing stairs</li></ul></li></ul>In addition to the above, the following conditions are also considered disabilities for children:<ul><li>Limited ability to do the things most children of the same age can do</li><li>Need or use more health care than is usual for most children of the same age</li><li>Receives special education services or services under a Section 504 plan</li></ul></p>",
    "en.is_applying_coverage" => "<b> Does this person need coverage? </b> <br> <br> If you need coverage, select ‘yes’. If you’re applying for coverage for someone else, but don’t need coverage for yourself, select ‘no’. If you don’t need or qualify for coverage, but someone in your family or that you include on your tax return does, you can apply on their behalf.",

    # Applicant Info
    "en.us_citizen" => "<b> Are you a US Citizen or US National? </b> <br> <br> You’re a US citizen if you were born in the US or certain US territories, had a parent who was a US citizen when you were born, or you became a US citizen through adoption or naturalization.<br> <br> A US national is a US citizen or anyone who owes permanent allegiance to the US.",
    "en.naturalized_citizen" => "<b> Are you a naturalized citizen? </b> <br> <br> A naturalized citizen is someone who wasn’t born a US citizen. A person can apply to be a naturalized citizen after being a permanent resident (green card holder) for a certain period of time, and if they meet certain other legal requirements.",
    "en.eligible_immigration_status" => "<b>Does this person have an eligible immigration status? </b> <br> <br> Anyone with an eligible immigration status may qualify to get health insurance coverage through DC Health Link. There are many eligible categories. Some common types include but aren’t limited to: <br> <ul> <li>Lawful permanent resident (LPR/green card holder)</li><li>Asylee or applicant for asylum who has an approved employment authorization</li><li>Refugee</li><li>Individuals with non-immigrant status, such as those who have:</li><ul><li>Worker visas</li><li>Student visas</li></ul><li>Temporary Protected Status (TPS) or applicants for TPS with an approved employment authorization</li><li>Victim of trafficking and his or her spouse, child, sibling, or parent, and applicants for a victim of trafficking visa</li></ul>If you don’t see your status on this list, <a href='https://dchealthlink.com/sites/default/files/v2/forms/Eligible%20Immigration%20Status%20List_0.pdf' target='_blank'> view the full list of eligible immigration statuses</a> to see if you may qualify to get coverage through DC Health Link.",
    "en.is_incarcerated" => "<b>Are you currently incarcerated? </b> <br> <br> Select 'yes' if any of the following situations apply: <br> <ul> <li> You're serving a term in prison or jail </li> <li> You're currently staying in a halfway house </li> </ul> <br> Select 'no' if: <ul> <li> You're on probation, parole, or home confinement </li> <li> You're being held in jail or prison, but haven't been convicted of a crime <br> (in other words, charges are pending)"

}
