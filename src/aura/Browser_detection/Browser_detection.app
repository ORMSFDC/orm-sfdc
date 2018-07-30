<aura:application access="GLOBAL" extends="ltng:outApp"  implements="ltng:allowGuestAccess">
    <aura:handler name="init" value="this" action="{!c.checkBrowser}"/>
    <aura:attribute name="show_popup" type="Boolean" default="true"/>
    
    <aura:if isTrue="{!v.show_popup}">
    	<div class="demo-only" style="height: 640px;">
  <section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true" aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
    <div class="slds-modal__container">
      <header class="slds-modal__header">
        <button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close">
          <span class="slds-assistive-text">Close</span>
        </button>
        <h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Modal Header</h2>
      </header>
      <div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1">
      <!--  <p>Please use CHROME for better experience...1</p> -->
          <p>To get the most out of your experience on our site, please update your browser to Google Chrome. Without Google Chrome, you may experience problems on the site.</p>
      </div>
      <footer class="slds-modal__footer">
        <button class="slds-button slds-button_neutral">Cancel</button>
        <button class="slds-button slds-button_brand">Save</button>
      </footer>
    </div>
  </section>
  <div class="slds-backdrop slds-backdrop_open"></div>
</div>
    
    
    </aura:if>
    
</aura:application>