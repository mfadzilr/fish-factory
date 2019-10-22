module ReportsHelper
  def get_browser_category(report)
    categories = RecipientDetail.where(campaign_id: report.campaigns.ids).group(:browser).count

    data = {
      labels: categories.keys.map { |ua| ua.first(45) },
      datasets: [
        {
          backgroundColor: [
            '#F7464A',
            '#46BFBD',
            '#FDB45C',
            '#949FB1',
            '#4D5360',
            '#F38630',
            '#007E33',
            '#BB7E33'
          ],
          pointBackgroundColor: "rgba(0, 126, 51, 1)",
          borderCapStyle: 'butt',
          borderDash: [],
          borderDashOffset: 0.0,
          borderJoinStyle: 'miter',
          pointBorderWidth: 1,
          pointHoverRadius: 5,
          spanGaps: false,
          data: categories.values
        }
      ]
    }
    return data
  end

  def get_platform_category(report)
    categories = RecipientDetail.where(campaign_id: report.campaigns.ids).group(:platform).count

    data = {
      labels: categories.keys.map { |ua| ua.first(45) },
      datasets: [
        {
          backgroundColor: [
            '#CC0000',
            '#CCEE00',
            '#FF8800',
            '#FF88AA',
            '#FFFF00',
            '#FF1100',
            '#007E33',
            '#BB7E33'
          ],
          pointBackgroundColor: "rgba(0, 126, 51, 1)",
          borderCapStyle: 'butt',
          borderDash: [],
          borderDashOffset: 0.0,
          borderJoinStyle: 'miter',
          pointBorderWidth: 1,
          pointHoverRadius: 5,
          spanGaps: false,
          data: categories.values
        }
      ]
    }
    return data
  end

  def get_activity_hours(report)
    activity_hours = RecipientDetail.where(campaign_id: report.campaigns.ids).group_by { |activity| activity.created_at.hour }

    campaign_activity = Hash.new

    (1..23).each do |i|
      if activity_hours[i].nil?
        campaign_activity[i] = 0
      else
        campaign_activity[i] = activity_hours[i].count
      end
    end

    data = {
      labels: (1..24).map { |hour| Time.parse("#{hour}:00").strftime("%l %P") },
      datasets: [
        {
          backgroundColor: "rgba(255,0,255,0.3)",
          pointBackgroundColor: "rgba(0, 126, 51, 1)",
          borderCapStyle: 'butt',
          borderDash: [],
          borderDashOffset: 0.0,
          borderJoinStyle: 'miter',
          pointBorderWidth: 1,
          pointHoverRadius: 5,
          spanGaps: false,
          data: campaign_activity.values
        }
      ]
    }
    return data
  end
end
