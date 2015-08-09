defmodule HelloPhoenix.HelloView do
  use HelloPhoenix.Web, :view

  def parse_query(query) do
    String.split(query, "\n", trim: true)
    |> Enum.map(&([min, hour, day, month, weekday, command] = String.split(&1, " ", parts: 6)))
    |> Enum.map(&(crontime_to_schedule(&1)))
  end

  defp crontime_to_schedule(crontime) do
    case crontime do
      [min, hour, day, month, weekday, command] -> 
        case [month, day, hour] do
         ["*", "*", "*"] -> ""
         ["*", "*", _] -> ""
         ["*", _, _] -> ""
         [_, _, _] -> "毎年"
        end
        <>
        case [month, day, hour] do
         ["*", "*", "*"] -> ""
         ["*", "*", _] -> ""
         ["*", _, _] -> "毎月"
         [month, _, _] -> "#{month}月"
        end
        <>
        case [weekday, day] do
         ["*", _] -> ""
         [weekday, "*"] -> "毎週" <> weekday_to_schedule(weekday)
         [weekday, _] -> weekday_to_schedule(weekday)
        end
        <>
        case [month, day] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         [_, day] -> "#{day}日"
        end
        <>
        case [weekday, day, hour] do
         ["*", "*", "*"] -> ""
         ["*", "*", _] -> "毎日"
         [_, _, _] -> ""
        end
        <>
        case [day, hour] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         [_, hour] -> "#{hour}時"
        end
        <>
        case [hour, min] do
         ["*", "*"] -> ""
         ["*", _] -> "毎時"
         [_, _] -> ""
        end
        <>
        case min do
         "*" -> "毎分"
         min -> "#{min}分"
        end
        <> "に#{command}"
    end
  end

  defp weekday_to_schedule(weekday) do
    case weekday do
      "0" -> "日曜日"
      "1" -> "月曜日"
      "2" -> "火曜日"
      "3" -> "水曜日"
      "4" -> "木曜日"
      "5" -> "金曜日"
      "6" -> "土曜日"
      _ -> ""
    end
  end
end
