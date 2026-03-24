/// JavaScript snippet injected into HTML responses in dev mode.
///
/// Polls the `/__dev/version` endpoint and refreshes the page when the
/// static change counter changes (indicating static files like HTML, CSS,
/// or JS were modified).
const devAutoRefreshScript = '''
<script>
(function() {
  var v = null;
  setInterval(function() {
    fetch('/__dev/version')
      .then(function(r) { return r.text(); })
      .then(function(t) {
        if (v !== null && v !== t) location.reload();
        v = t;
      })
      .catch(function() {});
  }, 500);
})();
</script>''';
