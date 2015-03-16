/*global d3 */

var formatDate = d3.time.format("%B %d, %Y"),
    formatMonthYear = d3.time.format("%B %Y"),
    formatYear = d3.time.format("%Y"),
    formatFixed = d3.format(",.0f"),
    params = d3.select("#api_key");

if (!params.empty()) {
  var api_key = params.attr('data-api_key');
  var page = params.attr('data-page');
  var per_page = params.attr('data-per_page');
  var q = params.attr('data-q');
  var class_name = params.attr('data-class_name');
  var publisher_id = params.attr('data-publisher_id');
  var source_id = params.attr('data-source_id');
  var order = params.attr('data-order');
  var model = params.attr('data-model');

  var query = encodeURI("/api/v5/articles?api_key=" + api_key);
  if (page !== "") { query += "&page=" + page; }
  if (per_page !== "") { query += "&per_page=" + per_page; }
  if (q !== "") { query += "&q=" + q; }
  if (class_name !== "") { query += "&class_name=" + class_name; }
  if (publisher_id !== "") { query += "&publisher_id=" + publisher_id; }
  if (source_id !== "") { query += "&source_id=" + source_id; }
  if (order !== "") { query += "&order=" + order; }
  if (source_id === "" && order === "") { query += "&info=summary"; }
}

// load the data from the Lagotto API
if (query) {
  d3.json(query, function(error, json) {
    if (error) { return console.warn(error); }
    worksViz(json);
    paginate(json);
  });
}

// add data to page
function worksViz(json) {
  data = json.data;

  json.href = "?page={{number}}";
  if (q !== "") { json.href += "&q=" + q; }
  if (class_name !== "") { json.href += "&class_name=" + class_name; }
  if (publisher_id !== "" && model != "publisher") { json.href += "&publisher_id=" + publisher_id; }
  if (source_id !== "") { json.href += "&source_id=" + source_id; }
  if (order !== "") { json.href += "&order=" + order; }

  d3.select("#loading-results").remove();

  if (data.length === 0) {
    d3.select("#content").text("")
      .insert("div")
      .attr("class", "alert alert-info")
      .text("There are currently no works");
    if (page === "") { d3.select("div#rss").remove(); }
    return;
  }

  d3.select("#content").insert("div")
    .attr("id", "results");

  for (var i=0; i<data.length; i++) {
    var work = data[i];
    var date_parts = work["issued"]["date-parts"][0];
    var date = datePartsToDate(date_parts);

    d3.select("#results").append("h4")
      .attr("class", "work")
      .append("a")
      .attr("href", function(d) { return "/works/" + work["id"]; })
      .html(work.title);
    d3.select("#results").append("span")
      .attr("class", "date")
      .text(formattedDate(date, date_parts.length) + ". ");
    d3.select("#results").append("a")
      .attr("href", function(d) { return url_for(work); })
      .text(url_for(work));
    d3.select("#results").append("p")
      .text(signpostsToString(work));
  }
}
