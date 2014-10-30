Academyclass::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  match "/bbx", to: redirect("/")
  match "/bartercard", to: redirect("/")

  namespace :admin do
    resources :news, :sidebar_items
  end

  resources :news_pages, :news

  match 'courses.xml' => 'courses#courses', :as => :xml_courses, :format => :xml
  match 'courses.csv' => 'courses#export', as: :csv_courses, format: :csv
  match 'courses/full.csv' => 'courses#full_export', as: :csv_courses_full, format: :csv
  match 'courses-plus.xml' => 'courses#courses_plus', :as => :xml_courses_plus, :format => :xml
  match 'courses-with-dates.xml' => 'courses#courses_with_dates', :as => :xml_courses_with_dates, :format => :xml
  match 'course-dates.xml' => 'courses#course_dates', :as => :xml_course_dates, :format => :xml
  match 'learn-pipe.xml' => 'courses#learn_pipe', :as => :xml_learn_pipe, :format => :xml
  match 'guarantee' => 'cms#guarantee', :as => :guarantee
  match 'discounts' => 'cms#discounts', :as => :discounts
  match 'newsletter_subscription' => 'email_logs#newsletter_subscription', :as => :newsletter_subscriptions, :via => :post
  match 'course_enquiry' => 'email_logs#course_enquiry', :as => :course_enquiries, :via => :post
  match 'course_detail_enquiry' => 'email_logs#course_detail_enquiry', :as => :course_detail_enquiries, :via => :post
  match 'creative_licence_enquiry' => 'email_logs#creative_licence_enquiry', :as => :creative_licence_enquiries, :via => :post
  match 'academy_class_club' => 'cms#club', :as => :ac_club
  match '/training/:product_parent/:product-training-course' => 'products#show', :as => :training_product
  match '/training/:product_parent/:product/:product2-training-course' => 'products#show'
  match '/training/:product_parent/:product-training-course/:id/:course' => 'courses#show', :as => :course_product_parent
  
  match 'auth/:provider/callback' => 'user_sessions#auth_callback'
  match 'auth/failure' => 'user_sessions#auth_failure'

  resources :product_parents, :products, :courses, :families, :events, :course_dates, :referrers, :user_sessions, :users, :payment_responses, :instructors, :booking_amendments
  resources :booking_forms do
    member do
      post 'complete'
      post 'cancel'
      get 'download'
    end
    collection do
      get 'search'
    end
  end

  match "/booking_delegates/:id/platform" => "booking_delegates#platform", via: :post, as: :platform_booking_delegate
  
  resources :footer_links, :only => [:index, :new, :create, :destroy]
  resources :prioritise, :only => [:update]
  resources :email_logs do
    collection do
      get :export, format: :csv
    end
  end
  resources :pages, :only => [:index, :edit, :update]
  resources :video_product_members, :video_features, :course_booking_mappings, :menu_groups, :top_courses, :testimonials
  resources :menu_items do
    collection do
      post 'sort'
    end
  end
  resources :video_tag_types do
    collection do
      post 'sort'
    end
  end
  
  resources :video_products do
    member do
      post 'copy_members'
    end
  end
  
  match 'online-training-videos' => 'videos#home', :as => :videos_home
  match 'online-training-videos/:product-videos' => 'videos#show', :as => :play_video_product
  match 'online-training-videos/:category/:tag' => 'videos#tagged', :as => :tagged_videos
  match 'online-training-videos/:category/:tag/:id/:slug' => 'videos#tagged', :as => :related_video
  match 'online-training-videos/:product-videos/:id/:slug' => 'videos#show', :as => :play_video

  resources :videos do
    collection do
      get :download_details
    end
  end
  
  resources :uploads, :questions, :survey_questions, :survey_responses, :survey_products, :trainers, :banners, :sales_contacts, :tweets
  resources :locations do
    collection do
      get :list
    end
  end

  resources :surveys do
    collection do
      get :complete
    end
  end
  
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match '/' => 'cms#index', :as => :root
  match 'admin' => 'user_sessions#new', :as => :admin_root
  match 'consultancy' => 'cms#consultancy', :as => :consultancy
  match 'creative-services' => 'cms#creative_services', :as => :creative_services
  match 'aboutus' => 'cms#aboutus', :as => :aboutus
  match 'contact' => 'email_logs#new', :as => :contact
  match 'training' => 'cms#training', :as => :training
  match 'training/private-training' => 'cms#private_training', :as => :private_training
  match 'aboutus/what-clients-say' => 'cms#what_clients_say', :as => :what_clients_say
  match 'meet-the-instructors' => 'cms#meet_the_instructors', :as => :meet_the_instructors
  match 'certifications' => 'cms#certifications', :as => :certifications
  
  match 'email/certification' => 'cms#certification'
  match 'email/blended_learning' => 'cms#blended_learning'
  match 'email/training_vouchers' => 'cms#training_vouchers'

  match 'save-with-creative-licence' => 'cms#creative_licence', :as => :creative_licence
  match 'new-creative-licence' => 'cms#new_creative_licence', :as => :new_creative_licence
  match 'training/:name' => 'product_parents#show', :as => :parent_pages, :name => /[-a-zA-Z]+/
  match 'search' => 'search#index', :as => :search
  match 'subscribe' => 'email_logs#index', :as => :subscribe
  match 'terms_and_conditions' => 'cms#terms_and_conditions', :as => :terms_and_conditions
  match 'terms_of_business' => 'cms#terms_of_business', :as => :terms_of_business
  match 'privacy_policy' => 'cms#privacy_policy', :as => :privacy_policy
  match 'sitemap(.:format)' => 'cms#sitemap', :as => :sitemap
  match 'view_event' => 'events#show', :as => :view_event
  match 'families/select_product/:id' => 'families#select_product', :as => :select_product
  match 'events_list' => 'events#list', :as => :events_list
  match 'surveys/questions' => 'surveys#questions', :as => :question_search
  match 'set_course_seats' => 'course_dates#set_course_seats', :as => :set_course_seats
  match 'survey_products/create' => 'survey_products#create', :as => :create_survey_product
  match 'testimonial/video/:id' => 'testimonials#video', :as => :testimonial_video
  match ':controller/:action.:format' => '#index'
  match '/:controller(/:action(/:id))'
end
