DiscountPercentArticleNotificationCriterium.seed(
  (10..100).step(10).map { |percent|
    { name: "Percent Discount #{percent}%", threshold_pct: percent }
  }
)
