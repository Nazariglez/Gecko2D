---
pageClass: api-docs
---
<script>
  export default {
    mounted() {
      let iFrameID = document.getElementById('api-docs-iframe');
      if(iFrameID) {
            iFrameID.style.height = (window.innerHeight - document.querySelector("header.navbar").offsetHeight) + "px";
      }
      let htmlEl = document.querySelector("html");
      htmlEl.style.overflow = "hidden";
    },

    beforeDestroy() {
        let htmlEl = document.querySelector("html");
        htmlEl.style.overflow = "auto";
    }
  }
</script>

<iframe id="api-docs-iframe" :src="$withBase('/api_docs')" frameBorder="0" style="width: 100%; height: 100%;"></iframe>
