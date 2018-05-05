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
        'assets': [
        {% for bullet in section[1] %}
          '{{ bullet }}'{% unless forloop.last %},{% endunless %}
        {% endfor %}
        ]
      {% endif %}
    {% endfor %}
  {% endfor %}
});
