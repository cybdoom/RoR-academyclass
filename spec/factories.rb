FactoryGirl.define do

  factory :product_parent do
    sequence(:name) {|s| "Adobe #{s}" }
    description "Lorem Ipsum..."
  end

  factory :product do
    sequence(:name) {|s| "Acrobat #{s}" }
    association :product_parent
  end


  factory :family do
    sequence(:name) {|s| "Web Development #{s}"}
    position 1
  end

  factory :product_family do
    association :product
    association :family
  end

  factory :course do
    sequence(:name) {|s| "XYZ #{s}"}
    cost 522.00
    duration 2
  end

  factory :course_product do
    association :course
    association :product
  end

  factory :location do
    title "London Head Office"
    address "123 London Street, London"
    name "London"
    longitude 0.154848
    latitude 12.15488
  end

  factory :course_date do
    association :location
    association :course
    start_date "2013-02-01"
    end_date "2013-02-03"
  end

  factory :contact do
    name "Joe SMith"
    company "Acme Corp"
    email "joe@acme.com"
    telephone "0794548448"
    interest "This is stupid"
    comments "Blah blah blah"
    response "Electric Telephone"
    newsletter 1
  end

  factory :creative_licence_enquiry do
    name "Joe"
    email "joe@test.com"
    type "CreativeLicenceEnquiry"
  end

  factory :page do
    name "Index"
    content "Lorem ipsum...."
  end

  factory :trainer do
    name "Sarah Parky"
  end

  factory :survey do
    name "Survey 1"
    location "My Basement"
    start_date "2010-11-25"
    end_date "2010-11-27"
  end

  factory :question do
    question "What is the meaning of life?"
    question_type Question::FREE_TEXT
  end

  factory :survey_question do
    association :survey
    association :question
  end

  factory :answer do
    association :survey_response
    answer "42"
    association :survey_question
  end

  factory :booking_form do
    valid_to Date.today >> 1
    vat_rate 17.5
    status BookingForm::ISSUED
  end

  factory :booking_delegate do
    name 'Owne Taylor'
    course_name 'Bespoke - Client Site'
    course_location 'London'
    start_date '2012-08-28'
    end_date '2012-08-30'
    platform_pc false
    price 797.00
    booking_type 'std'
  end
end