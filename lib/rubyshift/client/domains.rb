class RubyShift::Client
  module Domains
    def domains
      get("/domains")
    end

    def domains_by_owner(owner="@self")
      get("/domains", body: {owner: owner})
    end

    def domain(name)
      get("/domains/#{name}")
    end
    
    def domain_create(name, options={})
      post("/domains", body: {name: name}.merge(options))
    end

    def domain_update(name, options={})
      put("/domains/#{name}", body: options)
    end

    def domain_delete(name, options={})
      delete("/domains/#{name}", body: options)
    end

    def domain_remove_self(name)
      delete("/domain/#{name}/members/self")
    end

  end
end
