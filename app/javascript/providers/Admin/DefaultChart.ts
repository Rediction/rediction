import Chart from "chart.js";

const drawChart = (chartElmId: string, labelName: string) => {
  const chartElm: any = document.getElementById(chartElmId);
  const data: any = JSON.parse(chartElm.dataset.amounts);

  const labels: any = [];
  const countData: any = [];

  Object.keys(data).forEach((date: string) => {
    labels.push(date);
    countData.push(data[date]);
  });

  return new Chart(chartElm.getContext("2d"), {
    type: "line",
    data: {
      labels,
      datasets: [
        {
          label: labelName,
          data: countData,
          pointRadius: 5,
          lineTension: 0,
          pointBackgroundColor: "#fff",
          backgroundColor: "rgba(52,181,226,0.4)",
          borderColor: "#34B5E2"
        }
      ]
    },
    options: {
      scales: {
        yAxes: [
          {
            ticks: {
              beginAtZero: true,
              min: 0
            }
          }
        ]
      }
    }
  });
};

export default {
  drawChart
};
