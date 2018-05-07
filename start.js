---
permalink: /start.js
---
//UpUp.debug();
UpUp.start({
  'cache-version': '1.{{ site.time | date: "%d%m%Y%H%M%S%Z" }}',
  {% for section_hash in site.data.offline %}
    {% for section in section_hash %}
      {% if section[0] == 'content-url' %}
        'content-url': '{{ section[1] }}',
      {% elsif section[0] == 'assets' %}
        'assets': [{% for bullet in section[1] %} '{{ bullet }}'{% unless forloop.last %},{% endunless %}{% endfor %} ]
      {% endif %}
    {% endfor %}
  {% endfor %}
});

// https://stackoverflow.com/questions/13549997/how-to-append-all-href-link-with-redirector-url-via-javascript
var links = document.links;
var i = links.length;
while (i--) {
  if (links[i].getAttribute("href").slice(0, 4) != "http" ||
         links[i].getAttribute("href").slice(-4) == ".pdf") {
    continue;
  }
  if (links[i].getAttribute("href").slice(-1) == "/") {
    links[i].href = links[i].href + "{{ site.data.config.utm }}";
  } else {
    var href = links[i].getAttribute("href");
    if ( href.search(/\?/) > -1) {
      links[i].href = links[i].href + "&{{ site.data.config.utm }}";
    } else {
      links[i].href = links[i].href + "{{ site.data.config.utm }}";
    }
  }
}
