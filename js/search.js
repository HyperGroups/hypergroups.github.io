(function (global) {
  'use strict';

  function getQueryParam(name) {
    var params = new URLSearchParams(window.location.search);
    return (params.get(name) || '').trim();
  }

  function normalize(text) {
    return String(text || '').toLowerCase();
  }

  function scoreItem(item, terms) {
    var hay = normalize([item.title, item.category, item.excerpt, item.kind].join(' '));
    var score = 0;
    for (var i = 0; i < terms.length; i++) {
      var t = terms[i];
      if (!t) continue;
      if (normalize(item.title).indexOf(t) !== -1) score += 8;
      if (normalize(item.category).indexOf(t) !== -1) score += 4;
      if (hay.indexOf(t) !== -1) score += 2;
      else return 0;
    }
    return score;
  }

  function render(resultsEl, metaEl, query, hits) {
    resultsEl.innerHTML = '';
    if (!query) {
      metaEl.hidden = true;
      return;
    }
    metaEl.hidden = false;
    metaEl.textContent = hits.length
      ? ('找到 ' + hits.length + ' 条与「' + query + '」相关')
      : ('未找到与「' + query + '」相关的内容');

    hits.forEach(function (item) {
      var li = document.createElement('li');
      var date = document.createElement('span');
      date.className = 'post-date';
      date.textContent = item.date || (item.kind === 'page' ? '页面' : '');

      var a = document.createElement('a');
      a.href = item.url;
      a.textContent = item.title;

      li.appendChild(date);
      li.appendChild(a);
      if (item.excerpt) {
        var ex = document.createElement('p');
        ex.className = 'search-excerpt';
        ex.textContent = item.excerpt;
        li.appendChild(ex);
      }
      resultsEl.appendChild(li);
    });
  }

  function runSearch(index, query) {
    var terms = normalize(query).split(/\s+/).filter(Boolean);
    if (!terms.length) return [];
    return index
      .map(function (item) {
        return { item: item, score: scoreItem(item, terms) };
      })
      .filter(function (x) { return x.score > 0; })
      .sort(function (a, b) { return b.score - a.score; })
      .map(function (x) { return x.item; });
  }

  var SiteSearch = {
    init: function (opts) {
      var input = document.querySelector(opts.input);
      var form = document.querySelector(opts.form);
      var results = document.querySelector(opts.results);
      var meta = document.querySelector(opts.meta);
      if (!input || !form || !results || !meta) return;

      var index = [];
      var ready = fetch(opts.indexUrl, { credentials: 'same-origin' })
        .then(function (res) {
          if (!res.ok) throw new Error('index ' + res.status);
          return res.json();
        })
        .then(function (data) {
          index = Array.isArray(data) ? data : [];
        })
        .catch(function () {
          meta.hidden = false;
          meta.textContent = '搜索索引暂时不可用。';
        });

      function apply(query) {
        ready.then(function () {
          render(results, meta, query, runSearch(index, query));
        });
      }

      var initial = getQueryParam('q');
      if (initial) {
        input.value = initial;
        apply(initial);
      }

      form.addEventListener('submit', function (e) {
        e.preventDefault();
        var q = input.value.trim();
        var url = new URL(window.location.href);
        if (q) url.searchParams.set('q', q);
        else url.searchParams.delete('q');
        history.replaceState(null, '', url.toString());
        apply(q);
      });

      var timer;
      input.addEventListener('input', function () {
        clearTimeout(timer);
        timer = setTimeout(function () {
          apply(input.value.trim());
        }, 180);
      });
    }
  };

  global.SiteSearch = SiteSearch;
})(window);
