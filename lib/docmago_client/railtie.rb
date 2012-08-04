module DocmagoClient
  class Railtie < Rails::Railtie

    initializer "docmago_client" do |app|
      ActiveSupport.on_load :action_controller do
        DocmagoClient::Railtie.setup_actioncontroller
      end
    end
    
    def self.setup_actioncontroller
      unless Mime::Type.lookup_by_extension("pdf")
        Mime::Type.register "application/pdf", :pdf
      end

      ActionController::Renderers.add :pdf do |filename, options|
        default_options = {
          :name      => filename||controller_name,
          :test_mode => !Rails.env.production?,
        }
        options = default_options.merge(options)
        options[:content] ||= render_to_string(options)
            
        response = DocmagoClient.create(options)
        
        if response.code == 200
          send_data response, :filename => "#{options[:name]}.pdf", :type => "application/pdf", :disposition => "attachment"
        else
          render :inline => response.body, :status => response.code
        end
      end
    end
  end
end