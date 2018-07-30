({
    myAction : function(component, event, helper) {
        console.log('component.get("v.datasets") ',component.get("v.datasets"));
        debugger;
        var ctx = component.find("chart").getElement();  
        var chart = new Chart(ctx,{
            type: 'pie',
            data: {
                datasets: [{
                    data: component.get("v.datasets"),
                  //  backgroundColor: ['#ff6384','#cc65fe', '#0066ff','#36a2eb', '#ffce56',  '#b2d12b']
                    backgroundColor: ['#FF9B00', '#B5121B', '#0C4569', '#2081BF', '#ffce56', '#6C9F2E']               
                }],
                 // These labels appear in the legend and in the tooltips when hovering different arcs
                labels: component.get('v.labels')
   			 },
               	showDatapoints: true,
                options: {
                    tooltips: {
                        enabled: true,
                    },
                    pieceLabel: {
                        render: function(args){return '$'+args.value.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");},
                        position: 'outside',
                        fontColor: '#000'
                    },
                    responsive: true,
                    maintainAspectRatio : false,
                    legend: {
                        position: 'top',
                    },
                    animation: {
                        animateScale: true,
                        animateRotate: true
                    } 
                }
        });
        /*  var    chart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: component.get("v.labels"),
                    datasets: component.get("v.datasets")
                },
                options: {

                    tooltips: {
                        callbacks: {
                            title: function() {
                                return '';
                            },                            
                            beforeLabel: function(tooltipItem, data) { 
                                //return formatted date
                                return 'Age: '+tooltipItem.xLabel+' Years';
                            }
                        }
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
                                labelString: '',
                            }
                        }],
                        xAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: 'Age In Years'
                            }
                        }]
                    } 
                }
            });*/ 
        
    }
})