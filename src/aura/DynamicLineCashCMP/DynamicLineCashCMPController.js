({
	myAction : function(component, event, helper) {
        
//alert('cash 111');
       // alert(component.get("v.months"));
     //   console.log('chart ',component.get("v.chart"));
    var ctx1 = component.find("chart1").getElement();
            var chart1 = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: component.get("v.months"),
                    datasets: [{
                        data: component.get("v.bar"),
                        label: 'Cashflow($)',
                        backgroundColor: [
                            '#ff6384', '#36a2eb', "#000080"
                        ]
                    }]
                },
                options: {
                    animation: {
                        duration: 1
                       /* onComplete: function() {
                         //   alert('complete 123AAAA');
                            var chartInstance = component.get("v.chart"),
                               ctx1 = chartInstance.ctx;                            
                           ctx1.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize,
                                                                Chart.defaults.global.defaultFontStyle,
                                                               Chart.defaults.global.defaultFontFamily);
                       
                            ctx1.textAlign = 'center';
                            ctx1.textBaseline = 'bottom';    
                            comonent.get('component.get("v.data") ',component.get("v.data"));
                            component.get("v.data").forEach(function(dataset, i) {
                                var meta = chartInstance.controller.getDatasetMeta(i);
                                meta.data.forEach(function(bar, index) {
                                    var data = dataset.data[index];
                                    ctx1.fillText("$"+data, bar._model.x, bar._model.y - 5);
                                });
                            });
                        }*/
                    },                    
                    legend: {
                        display: false
                    },
                    responsive: true,
                    maintainAspectRatio: false, 
                    scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true,
                            userCallback: function(value, index, values) {
                                value = value.toString();
                                return '$' + value;
                            }
                        },
                        scaleLabel: {
                                display: true,
                                labelString: 'Cashflow',
                            
                            }
                    }]
                }
                }
            }); 
			
    }	
})