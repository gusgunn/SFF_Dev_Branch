<aura:application extends="force:slds">
    <!-- Page header -->
    <div class="slds-page-header" style="border-bottom: 1px solid #dddbda; box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.1);">
        <div class="slds-media">
            <div class="slds-media__figure">
                <lightning:icon iconName="utility:picklist" size="normal" alternativeText="Picklist icon"/>
            </div>
            <div class="slds-media__body">
                <h1 class="slds-page-header__title slds-truncate slds-align-middle">Picklist Service Component Sample App</h1>
                <p class="slds-text-body_small slds-line-height_reset">See the Picklist Service Component at work and experiment with it</p>
            </div>
        </div>
    </div>

    <!-- Page body -->
    <div style="max-width: 850px; margin: 2rem auto;">
        <c:service_PicklistRecordTypeSelector/>
    </div>
</aura:application>