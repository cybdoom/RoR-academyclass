ActiveAdmin.register Contact do
  index do
    column :name
    column :company
    column :email
    column :interest
    default_actions
  end
end