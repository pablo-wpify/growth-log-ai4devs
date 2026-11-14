Rails.application.routes.draw do
  # GL-02: solo iniciar y cerrar sesión; sin registro ni recuperación de contraseña.
  resource :session, only: %i[ new create destroy ]
  # GL-05 (P-15, P-16): «Personas» es la página de inicio con sesión; las
  # rutas van en español, como la interfaz. Solo lectura.
  root "people#index"
  resources :people, only: %i[ index show ], path: "personas" do
    # GL-06 (P-19): la captura rápida se abre desde la persona, en una página
    # propia (P-22).
    resources :feedback_entries, only: %i[ new create ], path: "entradas", path_names: { new: "nueva" }
  end
  # GL-06 (P-19): las acciones sobre una entrada no se anidan bajo la persona,
  # porque eso exigiría su alcance y rompería la lectura por autoría (PP-9).
  # Rutas explícitas para no exponer también PUT /entradas/:id.
  get "entradas/:id", to: "feedback_entries#show", as: :feedback_entry
  get "entradas/:id/editar", to: "feedback_entries#edit", as: :edit_feedback_entry
  patch "entradas/:id", to: "feedback_entries#update"
  patch "entradas/:id/marcar-lista", to: "feedback_entries#mark_ready", as: :mark_ready_feedback_entry
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
