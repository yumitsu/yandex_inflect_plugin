class YandexInflectDbGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'migration:migration.rb', "db/migrate", {:assigns => migration_assigns,
        :migration_file_name => "create_inflections"
      }
    end
  end
  
  def migration_assigns
    returning(assigns = {}) do
      assigns[:migration_action] = "create"
      assigns[:class_name] = "create_inflections"
      assigns[:table_name] = custom_file_name
      assigns[:attributes] = [Rails::Generator::GeneratedAttribute.new("original_word", "string")]
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("inflected_variants", "text")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("original_word", "index")
    end
  end
end
