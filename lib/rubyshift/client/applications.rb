class RubyShift::Client
  module Applications
    def applications(options={})
      if options[:domain_name]
        get("/domain/#{options[:domain_name]}/applications", query: options)
      else
        get("/applications", query: options)
      end
    end

    def application(id)
      get("/application/#{id}")
    end

    def application_resolve(id)
      get("/application/#{id}/dns_resolvable")
    end
    
    def application_create(name, options={})
      url = "/domain/#{options[:domain_name]}/applications"
      post(url, body: {name: name }.merge(options))
    end

    def application_update(id, options={})
      put("/application/#{id}", body: options)
    end

    def application_delete(id)
      delete("/application/#{id}")
    end

    def application_enable_ha(id)
      post("/application/#{id}/events", body: {event: 'make-ha'})
    end

    def application_disable_ha(id)
      post("/application/#{id}/events", body: {event: 'disable-ha'})
    end
    
    def application_start(id)
      post("/application/#{id}/events", body: {event: 'start'})
    end
    
    def application_stop(id)
      post("/application/#{id}/events", body: {event: 'stop'})
    end

    def application_force_stop(id)
      post("/application/#{id}/events", body: {event: 'force-stop'})
    end

    def application_restart(id)
      post("/application/#{id}/events", body: {event: 'restart'})
    end

    def application_reload(id)
      post("/application/#{id}/events", body: {event: 'reload'})
    end
    
    def application_scale_up(id)
      post("/application/#{id}/events", body: {event: 'scale-up'})
    end

    def application_scale_up(id)
      post("/application/#{id}/events", body: {event: 'scale-up'})
    end

    def application_scale_down(id)
      post("/application/#{id}/events", body: {event: 'scale-down'})
    end
    
    def application_tidy(id)
      post("/application/#{id}/events", body: {event: 'tidy'})
    end
    
    
  end
end
