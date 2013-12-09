$(function () {
	
    var total_money = parseFloat($('#total_money').html());
    if(total_money == 0)
        total_money = 1;
    console.log(total_money);
	if($("#wines-stat-holder").length>0)
	{
	    var values = [],
	        labels = [];
	    $(".wine-pie-row").each(function () {
	        values.push(Math.round(parseFloat($("td.wine-money-count", this).text())*100/total_money));
	        labels.push($("td.wine-name", this).text());
	    });
	   
       console.log(values);
	    //Raphael("holder", 400, 330).pieChart(190, 165, 100, values, labels, "#fff");
	    var r = Raphael("wines-stat-holder",600,330),
	                    pie = r.piechart(400, 165, 100, values, { legend: labels, legendpos: "west", legendothers: "Otro", maxSlices: 17});
	
        //r.text(190, 100, "Llamadas").attr({ font: "20px sans-serif" });
        pie.hover(function () {
            this.sector.stop();
            this.sector.scale(1.1, 1.1, this.cx, this.cy);

            if (this.label) {
                this.label[0].stop();
                this.label[0].attr({ r: 7.5 });
                this.label[1].attr({ "font-weight": 800 });
            }
        }, function () {
            this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");

            if (this.label) {
                this.label[0].animate({ r: 5 }, 500, "bounce");
                this.label[1].attr({ "font-weight": 400 });
            }
        });
    }
    if($("#dispensers-stat-holder").length>0)
    {
        var values = [],
            labels = [];
        $(".dispenser-pie-row").each(function () {
            values.push(Math.round(parseFloat($("td.dispenser-money-count", this).text())*100/total_money));
            labels.push($("td.dispenser-name", this).text());
        });
       
       console.log(values);
        //Raphael("holder", 400, 330).pieChart(190, 165, 100, values, labels, "#fff");
        var r = Raphael("dispensers-stat-holder",390,330),
                        pie = r.piechart(200, 165, 100, values, { legend: labels, legendpos: "west", legendothers: "Otro", maxSlices: 17});
    
        //r.text(190, 100, "Llamadas").attr({ font: "20px sans-serif" });
        pie.hover(function () {
            this.sector.stop();
            this.sector.scale(1.1, 1.1, this.cx, this.cy);

            if (this.label) {
                this.label[0].stop();
                this.label[0].attr({ r: 7.5 });
                this.label[1].attr({ "font-weight": 800 });
            }
        }, function () {
            this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");

            if (this.label) {
                this.label[0].animate({ r: 5 }, 500, "bounce");
                this.label[1].attr({ "font-weight": 400 });
            }
        });
    }
});
