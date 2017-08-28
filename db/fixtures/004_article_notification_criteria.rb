DiscountPercentArticleNotificationCriterium.seed(
  (10..100).step(10).map do |percent|
    { name:          "Percent Discount #{percent}%",
      threshold_pct: percent }
  end
)
