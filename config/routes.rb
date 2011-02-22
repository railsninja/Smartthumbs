Rails::Application.routes.draw do
  match '/th/*path', :controller => "thumbs", :action => "deliver_crop"
end
