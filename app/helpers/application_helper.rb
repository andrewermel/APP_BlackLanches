module ApplicationHelper
  def format_currency(amount)
    symbol = t("currency.symbol")
    format = t("currency.format")
    formatted_amount = number_with_precision(amount || 0, precision: 2)
    format.gsub("%s", symbol).gsub("%n", formatted_amount)
  end

  def language_options
    [
      [ t("language.portuguese"), "pt-BR" ],
      [ t("language.english"), "en" ]
    ]
  end

  def current_language_name
    case I18n.locale.to_s
    when "pt-BR"
      t("language.portuguese")
    when "en"
      t("language.english")
    end
  end
end
