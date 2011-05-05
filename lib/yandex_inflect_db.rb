# -*- encoding: utf-8 -*- 
$KCODE = 'u'

require 'i18n'

######
# I18n.i('хуй', 'рд')
# i('хуй', 'рд')

if I18n.locale == :ru
  YandexInflect.instance_eval do
    self::CASES = %w{им ро да ви тв пр}
    
    def store_inflections(word, inflections)
      inflections = ActiveSupport::JSON.encode(inflections)
      Inflection.create!(:original_word => word, :inflected_variants => inflections)
    end
    
    def get_stored_inflections(word, no_cache = false)
      inflections = []
      
      unless no_cache
        result = cache_lookup(word)
        return result if result
      end
      
      result = Inflection.find_by_original_word(word)
      unless result.nil?
        inflections = ActiveSupport::JSON.decode(result.inflected_variants)
      else
        inflections = inflections(word)
        store_inflections(word, inflections)
      end
      
      inflections
    end
  end
  
  I18n.instance_eval do
    def inflect(word, kase)
      kase = YandexInflect::CASES.include?(kase) ? YandexInflect::CASES.find_index(kase) : 0
      inflections = YandexInflect.get_stored_inflections(word)
      return inflections[kase]
    end
  end
  
  if defined?(ActionController::Translation) 
    ActionController::Translation.instance_eval do
      def inflect(*args)
        I18n.inflect(*args)
      end
      
      alias :i :inflect
    end
  end
else
  YandexInflect.instance_eval do
    def no_locale
      raise 'You should have russian locale yo use this version of yandex_inflect'
    end
    
    alias :store_inflections :no_locale
    alias :get_stored_inflections :no_locale
  end
end