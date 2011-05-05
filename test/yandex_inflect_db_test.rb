# -*- encoding: utf-8 -*- 

$KCODE = 'u'

require 'test_helper'

I18n.locale = :ru

if RUBY_PLATFORM == "java"
  database_adapter = "jdbcsqlite3"
else
  database_adapter = "sqlite3"
end

File.unlink('test.sqlite3') rescue nil

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN
ActiveRecord::Base.establish_connection(
  :adapter => database_adapter,
  :database => 'test.sqlite3'
)

ActiveRecord::Base.connection.create_table(:inflections, :force => true) do |t|
  t.string :original_word
  t.text :inflected_variants
end

class Inflection < ActiveRecord::Base
end

# Подключение yandex_inflect вынесено сюда из-за проверки на существование модели Inflection
#$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
#require File.dirname(__FILE__) + '/init.rb'
#Dir.chdir(File.dirname(__FILE__))

class YandexInflectDbTest < ActiveSupport::TestCase
  def setup
    @test_word = 'тест'
    @not_inflected_results = ['тест','тест','тест','тест','тест','тест']
    @inflected_results = ['тест','теста','тесту','теста','тестом','тесте']
    @test_case_num = 1
    @test_case_text = 'ро'
  end
  
  def teardown
    #Inflection.delete_all
  end
  
  def test_locale_should_be_russian
    assert (I18n.locale == :ru), "Checked if I18n serving russian locale"
  end
  
  def test_additional_methods_defined
    assert_not_nil (defined?(YandexInflect.store_inflections) && defined?(YandexInflect.get_stored_inflections)), "Checked if additional methods defined"
  end
  
  def test_inflection_model_saves_data
    YandexInflect.store_inflections(@test_word, @not_inflected_results)
    inflections = YandexInflect.get_stored_inflections(@test_word)
    assert (inflections == @not_inflected_results)
  end
  
  def test_inflection_model_saves_inflected_words
    inflections = YandexInflect.get_stored_inflections(@test_word)
    assert (inflections == @inflected_results)
  end
  
  def test_inflections_valid_for_defined_case
    inflected_word = I18n.inflect(@test_word, @test_case_text)
    assert (inflected_word == @inflected_results[@test_case_num])
  end
end
