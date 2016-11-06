require 'buyma_insider'
require 'minitest/autorun'

class CrawlSessionTest < Minitest::Test
  def helper_get_crawl_history
    finished_at = Time.now.utc
    CrawlHistory.new(items_count:         1,
                     invalid_items_count: 1,
                     traffic_size:        2,
                     created_at:          finished_at - 2.seconds,
                     finished_at:         finished_at)
  end

  def test_should_respond_to_methods
    subject = CrawlSession.new
    assert_respond_to(subject, :started_at)
    assert_respond_to(subject, :finished_at)
    assert_respond_to(subject, :items_count)
    assert_respond_to(subject, :invalid_items_count)
    assert_respond_to(subject, :traffic_size)
  end

  def test_should_sum
    subject         = CrawlSession.new
    crawl_histories = 3.times.map { helper_get_crawl_history }

    subject.stub :crawl_histories, crawl_histories do
      assert_equal(3, subject.items_count)
      assert_equal(3, subject.invalid_items_count)
      assert_equal(6, subject.traffic_size)
      assert_equal(6, subject.elapsed_time)
    end
  end

  def test_should_give_started_at_and_finished_at
    subject         = CrawlSession.new
    crawl_histories = 3.times.map { helper_get_crawl_history }

    subject.stub :crawl_histories, crawl_histories do
      started_at_expected  = crawl_histories.map(&:created_at).min
      finished_at_expected = crawl_histories.map(&:finished_at).max
      assert_equal started_at_expected, subject.started_at
      assert_equal finished_at_expected, subject.finished_at
    end
  end
end