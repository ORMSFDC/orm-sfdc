/**
 * @description: Object representation of the parsed Fannie Mae response.
 * @author: Ravi
 * NOTE: DO NOT DELETE ANY COMMENTED FIELDS AS THEY MAY BE USED FOR FUTURE MAPPINGS
 * changelog:
 * 02/04/2019: Sahitya Modified code to map 3.2 with HMDA race, ethnicity, sex fields
 */

public class FNMResponse {
    public Boolean wasSuccessful {get; set;}
    public TenOhThree tenOhThree {get; set;}
    //public List<Warnings> warnings {get; set;}
    //public List<DependentsAge> errors {get; set;}
    //public List<FieldList> fieldList {get; set;}
    //public Boolean wasInputSorted {get; set;}
    //public String applicationId {get; set;}
    
    public class TenOhThree {
        //public EnvelopeHeader envelopeHeader ;
        //public TransactionHeader transactionHeader ;
        //public TransactionProcessingInfo transactionProcessingInfo {get; set;}
        //public List<FileIdentification> fileIdentification {get; set;}
        //public TopOfForm topOfForm {get; set;}
        //public MortgageTypeAndTerms mortgageTypeAndTerms {get; set;}
        public PropertyInformation propertyInformation {get; set;}
        //public PropertyAddressInformation propertyAddressInformation {get; set;}
        public LoanPurpose loanPurpose {get; set;}
        public List<TitleHolders> titleHolders {get; set;}
        //public ConstructionOrRefinanceData constructionOrRefinanceData {get; set;}
        //public List<DownPayments> downPayments {get; set;}
        public List<ApplicantData> applicantData {get; set;}
        //public List<DependentsAge> dependentsAge {get; set;}
        public List<ApplicantsAddress> applicantsAddress {get; set;}
        public List<PrimaryCurrentEmployers> primaryCurrentEmployers {get; set;}
        public List<SecondOrPreviousEmployers> secondOrPreviousEmployers {get; set;}
        public List<PresentOrProposedHousingExpense> presentOrProposedHousingExpense {get; set;}
        public List<Income> income {get; set;}
        public List<LifeInsurance> lifeInsurance {get; set;}
        public List<Assets> assets {get; set;}
        //public List<Automobiles> automobiles {get; set;}
        public List<AlimonyOrChildSupportOrJobRelatedExpenses> alimonyOrChildSupportOrJobRelatedExpenses {get; set;}
        public List<RealEstateOwned> realEstateOwned {get; set;}
        //public List<Aliases> aliases {get; set;}
        public List<Liabilities> liabilities {get; set;}
        //public List<UndrawnHELOCAndIPCs> undrawnHELOCAndIPCs {get; set;}
        public DetailsOfTransaction detailsOfTransaction {get; set;}
        //public List<OtherCredits> otherCredits {get; set;}
        public List<Declarations> declarations {get; set;}
        //public List<DeclarationExplanations> declarationExplanations {get; set;}
        //public List<AcknowledgementAndAgreement> acknowledgementAndAgreement {get; set;}
        public List<GovernmentMonitoringInfo> governmentMonitoringInfo {get; set;}
        public LoanOriginator loanOriginator {get; set;}
        public List<Races> races {get; set;}
        public FannieMaeTransmittalData fannieMaeTransmittalData {get; set;}
        //public List<AdditionalDataSegments> additionalDataSegments {get; set;}
        //public List<Score> score {get; set;}
        //public LoanCharacteristics loanCharacteristics {get; set;}
        //public ProductIdentification productIdentification {get; set;}
        //public ProductCharacteristics productCharacteristics {get; set;}
        //public ARM arm {get; set;}
        //public List<PaymentAdjustment> paymentAdjustment {get; set;}
        //public List<RateAdjustment> rateAdjustment {get; set;}
        //public BuydownData buydownData {get; set;}
        //public CasefileIdentification casefileIdentification {get; set;}
        //public LenderData lenderData {get; set;}
        public FHAAndVALoanData fhaAndVALoanData {get; set;}        
        public List<AdditionalDataSegments> additionalDataSegments; /*02/04 HMDA*/
        //public FHALoanOnlyData fhaLoanOnlyData {get; set;}
        //public VALoanOnlyData vaLoanOnlyData {get; set;}
        //public List<VALoanOnlyExtraData> vaLoanOnlyExtraData {get; set;}
        //public List<CreditData> creditData {get; set;}
        //public CommunityLendingLoanData communityLendingLoanData {get; set;}
        //public TransactionTrailer transactionTrailer {get; set;}
        //public EnvelopeTrailer envelopeTrailer {get; set;} 
    }
    
    //public class EnvelopeHeader {
    //    public String institutionID {get; set;}
    //    public String institutionName {get; set;}
    //    //Getting date parameter error as variable date is a keyword
    //    //public Datetime date;
    //    public String envelopeControlNumber {get; set;}
    //}
    
    //public class TransactionHeader {
    //    public String transactionID {get; set;}
    //    public String transactionControlNumber {get; set;}
    //}
    
    //public class TransactionProcessingInfo {
    //    public String versionID {get; set;}
    //    public String identifierTypeCode {get; set;}
    //    public String identifier {get; set;}
    //    public Integer importAction {get; set;}
    //}
    
    //public class FileIdentification {
    //    public String fileType {get; set;}
    //    public String fileVersionID {get; set;}
    //    public String exportVersionIndicator {get; set;}
    //    //Declared in dll Class but not getting value in the JSON Response
    //    //private boolean fullParser;
    //}
    
    //public class TopOfForm {
    //    public Boolean incomeOrAssetsOfNonBorrower {get; set;}
    //    public Boolean incomeOrAssetsOfSpouse {get; set;}
    //}
    
    //public class MortgageTypeAndTerms {
    //    public String mortgageAppliedFor {get; set;}
    //    public String mortgageAppliedForOther {get; set;}
    //    public String agencyCaseNumber {get; set;}
    //    public String caseNumber {get; set;}
    //    public decimal loanAmount {get; set;}
    //    public decimal interestRate {get; set;}
    //    public Integer numOfMonths {get; set;}
    //    public String amortizationType {get; set;}
    //    public String amortizationTypeOther {get; set;}
    //    public String armDescription {get; set;}
    //}
    
    public class PropertyInformation {
        public PropertyAddress propertyAddress {get; set;}
        public Integer numberOfUnits {get; set;}
        //public String legalDescriptionPropertyCode {get; set;}
        public String legalDescriptionPropertyText {get; set;}
        public Integer yearBuilt {get; set;}
    }
    
    //public class PropertyAddressInformation{
    //    public string houseNumber {get; set;}
    //    public string streetName {get; set;}
    //    public string unitNumber {get; set;}
    //}
    
    public class LoanPurpose {
        public String purposeOfLoan {get; set;}
        //public String purposeOfLoanOther {get; set;}
        public String propertyWillBe {get; set;}
        //public String mannerTitleHeld {get; set;}
        public String estateHeldIn {get; set;}
        //public Datetime leaseExpirationDate {get; set;}
    }
    
    public class TitleHolders {
        public String titleHolderName {get; set;}
    }
    
    //public class ConstructionOrRefinanceData {
    //    public integer yearAcquired {get; set;}
    //    public decimal originalCost {get; set;}
    //    public decimal existingLiensAmount {get; set;}
    //    public decimal presentValueOfLot {get; set;}
    //    public decimal costOfImprovements {get; set;}
    //    public String purposeOfRefinance {get; set;}
    //    public String describeImprovements {get; set;}
    //    public Integer describeImprovementsStatus {get; set;}
    //    public decimal describeImprovementsCost {get; set;}
    //}
    
    //public class DownPayments {
    //    public string downPaymentType {get; set;}
    //    public decimal downPaymentAmount {get; set;}
    //    public string downPaymentExplanation {get; set;}
    //}
    
    public class ApplicantData {
        //public Integer applicantType {get; set;}
        public String ssn {get; set;}
        public String firstName {get; set;}
        public String middleName {get; set;}
        public String lastName {get; set;}
        //public String generation {get; set;}
        public String homePhone {get; set;}
        //public Integer age {get; set;}
        public Integer yearsOfSchool {get; set;}
        public Integer maritalStatus {get; set;}
        public Integer dependents {get; set;}
        //public Boolean completedJointly {get; set;}
        //public String crossReferenceNumber {get; set;}
        public Datetime dateOfBirth {get; set;}
        public String emailAddress {get; set;}
    }
    
    //public class DependentsAge {
    //    public string ssn {get; set;}
    //    public integer dependentsAge {get; set;}
    //}
    
    public class ApplicantsAddress {
        public String ssn {get; set;}
        public Integer addressType {get; set;}
        public ResidenceAddress residenceAddress {get; set;}
        public Integer residenceOwnership {get; set;}
        public Integer yearsAtResidence {get; set;}
        //public Integer monthsAtResidence {get; set;}
    }
    
    public class PrimaryCurrentEmployers {
        public String ssn {get; set;}
        public String employerName {get; set;}
        public PropertyAddress employerAddress {get; set;}
        public Boolean selfEmployed {get; set;}
        public Integer yearsOnJob {get; set;}
        public Integer monthsOnJob {get; set;}
        public Integer yearsInLineOfWork {get; set;}
        public String position {get; set;}
        public String businessPhone {get; set;}
    }
    
    public class SecondOrPreviousEmployers{
        public string ssn {get; set;}
        public string employerName {get; set;}
        public ResidenceAddress employerAddress {get; set;}
        public boolean selfEmployed {get; set;}
        public boolean currentEmployment {get; set;}
        public dateTime fromDate {get; set;}
        public dateTime toDate {get; set;}
        public decimal monthlyIncome {get; set;}
        public string position {get; set;}
        public String businessPhone {get; set;}
    }
    
    public class PresentOrProposedHousingExpense {
        //public String ssn {get; set;}
        public String presentProposedIndicator {get; set;}
        public String housingPaymentTypeCode {get; set;}
        public decimal monthlyHousingExpense {get; set;}
    }
    
    public class Income {
        public String ssn {get; set;}
        public String typeOfIncomeCode {get; set;}
        public decimal monthlyIncomeAmount {get; set;}
    }
    
    public class LifeInsurance{
        public string ssn {get; set;}
        //public string accountNumber {get; set;}
        //public decimal lifeInsuranceCashOrMarketValue {get; set;}
        public decimal lifeInsuranceFaceAmount {get; set;}
    }
    
    public class Assets {
        public String ssn {get; set;}
        public String assetType {get; set;}
        public String depositoryName {get; set;}
        public PropertyAddress depositoryAddress {get; set;}
        public String accountNumber {get; set;}
        public decimal cashOrMarketValue {get; set;}
        //public Integer numberOfStocksOrBondShares {get; set;}
        //public String assetDescription{get; set;}
    }
    
    //public class Automobiles{
    //    public string ssn {get; set;}
    //    public string autoMobileMakeModel {get; set;}
    //    public Integer automobileYear {get; set;}
    //    public decimal cashOrMarketValue {get; set;}
    //}
    
    public class AlimonyOrChildSupportOrJobRelatedExpenses {
        public String ssn {get; set;}
        public Integer expenseTypeCode {get; set;}
        public decimal monthlyPaymentAmount {get; set;}
        //public Integer monthsLeftToPay {get; set;}
        public string alimonyOwedTo {get; set;}
    }
    
    public class RealEstateOwned {
        public String ssn {get; set;}
        public PropertyAddress propertyAddress {get; set;}
        //public Integer propertyDisposition {get; set;}
        public String propertyType {get; set;}
        public decimal presentMarketValue {get; set;}
        public decimal amountOfMortgagesAndLiens{get; set;}
        public decimal grossRentalIncome {get; set;}
        public decimal mortgagePayments {get; set;}
        public decimal insuranceMaintenanceTaxesAndMisc {get; set;}
        public decimal netRentalIncome {get; set;}
        //public Boolean isCurrentResidence {get; set;}
        //public Boolean isSubjectProperty {get; set;}
        //public Integer reoAssetID {get; set;}
    }
    
    //public class Aliases{
    //    public string ssn {get; set;}
    //    public string alternateFirstName {get; set;}
    //    public string alternateMiddleName {get; set;}
    //    public string alternateLastName {get; set;}
    //}
    
    public class Liabilities {
        public String ssn {get; set;}
        public Integer liabilityType {get; set;}
        public String creditorName {get; set;}
        public PropertyAddress creditorAddress {get; set;}
        public String accountNumber{get; set;}
        public decimal monthlyPaymentAmount {get; set;}
        public Integer monthsLeftToPay {get; set;}
        public decimal unpaidBalance {get; set;}
        public Boolean liabilityWillBePaidByClosing {get; set;}
        //public Integer reoAssetID {get; set;}
        //public Boolean isResubordinated {get; set;}
        //public Boolean isOmitted {get; set;}
        //public Boolean isSubjectProperty {get; set;}
        //public Boolean isRentalProperty {get; set;}
    }
    
    //public class UndrawnHELOCAndIPCs{
    //    public string ssn {get; set;}
    //    public string summaryAmountTypeCode {get; set;}
    //    public decimal amount {get; set;}
    //}
    
    public class DetailsOfTransaction {
        public decimal purchasePrice {get; set;}
        public decimal alterationsImprovementsRepairsCost {get; set;}
        public decimal landCost {get; set;}
        public decimal refinanceCost {get; set;}
        public decimal estimatedPrepaidItemsAmount {get; set;}
        public decimal estimatedClosingCosts {get; set;}
        public decimal mortgageInsuranceFundingFee {get; set;}
        public decimal discountAmount {get; set;}
        public decimal subordinateFinancingAmount {get; set;}
        public decimal applicantsClosingCostsPaidBySeller {get; set;}
        public decimal mortgageInsuranceFundingFeeFinanced {get; set;}
    }
    
    //public class OtherCredits {
    //    public string otherCreditTypeCode {get; set;}
    //    public decimal otherCreditAmount {get; set;}
    //}
    
    public class Declarations {
        public String ssn {get; set;}
        public Boolean outstandingJudgments {get; set;}
        public Boolean declaredBankruptcy {get; set;}
        //public Boolean forclosedOrDeedInLieu {get; set;}
        public Boolean partyToLawsuit {get; set;}
        //public Boolean obligatedOnLoanForeclosed {get; set;}
        public Boolean delinquencyOrDefault {get; set;}
        //public Boolean alimonyOrChildSupport {get; set;}
        //public Boolean partOfDownPaymentBorrowed {get; set;}
        public Boolean coMakerOrEndorserOnNote {get; set;}
        public String citizenShip {get; set;}
        public Integer doYouIntendToOccupy {get; set;}
        //public Integer haveYouHadAnOwnershipInterest {get; set;}
        //public String whatTypeOfProperty {get; set;}
        //public String howDoYouHoldTitle {get; set;}
    }
    
   
    
    public class GovernmentMonitoringInfo {
        public String ssn {get; set;}
        //public Boolean clientWillNotFurnishedGovtMonitoring {get; set;}
        public String ethnicity {get; set;}
        public Integer sex {get; set;}
    }
    
    public class LoanOriginator {
        public Integer applicationTakenBy {get; set;}
        public String loanOriginatorsName {get; set;}
        public Datetime interviewDate {get; set;}
        public String loanOriginatorsPhoneNumber {get; set;}
        public String loanOriginationCompanyName {get; set;}
        public PropertyAddress loanOriginatorsAddress {get; set;}
    }
    
    public class Races {
        public String ssn {get; set;}
        public String race {get; set;}
    }
       public class FHAAndVALoanData{
        public boolean energyEfficientNewHome {get; set;}
        public decimal mortgageCreditCertificate {get; set;}
        public decimal sellerConcessions {get; set;}
        public decimal borrowerTotalClosingCostsFees {get; set;}
        public decimal borrowerTotalClosingCostsPoints {get; set;}
        public decimal sellerTotalClosingCostsFees {get; set;}
        public decimal sellerTotalClosingCostsPoints {get; set;}
        public decimal otherTotalClosingCostsFees {get; set;} 
        public decimal otherTotalClosingCostsPoints {get; set;}
        public string typeOfRefinance {get; set;}
        public string propertyOfCounty {get; set;}
    }
     public class ResidenceAddress {
        public String streetAddress {get; set;}
        public String streetAddress2 {get; set;}
        public String city {get; set;}
        public String zipCode {get; set;}
        public String zipCodePlusFour {get; set;}
        public Integer state {get; set;}
        //public String country {get; set;}
    }
    
    public class PropertyAddress {
        public String streetAddress {get; set;}
        public String streetAddress2 {get; set;}
        public String city {get; set;}
        public String zipCode {get; set;}
        public String zipCodePlusFour {get; set;}
        public Integer state {get; set;}
        //public String country {get; set;}
    }
    public class FannieMaeTransmittalData {
        //    public boolean sellerProvidedBelowMarketFunding {get; set;}
        //    public String ownerOfExistingMortgage {get; set;}
        public decimal propertyAppraisedValue {get; set;}
        //    public decimal buydownRate {get; set;}
        //    public String appraisedValueIndicator {get; set;}
        //    public String appraisalFieldworkOrdered {get; set;}
        //    public String appraiserName {get; set;}
        //    public String appraiserCompany {get; set;}
        //    public String appraiserLicenseNumber {get; set;}
        //    public String appraiserLicenseStateCode {get; set;}
    }
     //public class DeclarationExplanations{
    //    public string ssn {get; set;}
    //    public string declarationTypeCode {get; set;}
    //    public string declarationExplanation {get; set;}
    //}
    
    //public class AcknowledgementAndAgreement {
    //    public String ssn {get; set;}
    //    public Datetime signatureDate {get; set;}
    //}
    /*02/04 HMDA*/
    public class AdditionalDataSegments {
        public Integer additionalDataSegmentType {get; set;}
        public String additionalDataSegmentValue {get; set;}
    }
    
    //public class Score{
    //    public string fannieMaeScoreID {get; set;}
    //    public string fannieMaeScoreValue {get; set;}
    //    public DateTime fannieMaeScoreDate {get; set;}
    //}
    
    //public class LoanCharacteristics {
    //    public decimal negativeAmortizationLimitPercent {get; set;}
    //    public boolean isBalloonRequired {get; set;}
    //    public boolean hasHomebuyerEducationCompletion {get; set;}
    //    public decimal maximumLifetimeRateIncrease {get; set;}
    //    public decimal paymentAdjustmentLifePercentCap {get; set;}
    //    public decimal paymentAdjustmentLifeAmountCap {get; set;}
    //    public Boolean willEscrowBeWaived {get; set;}
    //    public Datetime scheduledClosingDate {get; set;}
    //    public Datetime scheduledFirstPaymentDate {get; set;}
    //    public decimal miCoveragePercent {get; set;}
    //    public String aprSpread {get; set;}
    //    public Boolean hoepa {get; set;}
    //    public Boolean isPreApproved {get; set;}
    //    public String lienType {get; set;}
    //    public Integer loanDocumentationType {get; set;}
    //    public String subjectPropertyType {get; set;}
    //    public String projectClassification {get; set;}
    //    public String miInsurer {get; set;}
    //}
    
    //public class ProductIdentification {
    //    public String productDescription {get; set;}
    //    public String productCode {get; set;}
    //    public String productPlanNumber {get; set;}
    //}
    
    //public class ProductCharacteristics {
    //    public String mortgageTerm {get; set;}
    //    public boolean assumableLoanIndicator {get; set;}
    //    public String paymentFrequencyCode {get; set;}
    //    public boolean prepaymentPenaltyIndicator {get; set;}
    //    public boolean prepaymentRestrictedIndicator {get; set;}
    //    public Integer repaymentTypeCode {get; set;}
    //}
    
    //public class ARM{
    //    public decimal aRMIndexValue {get; set;}
    //    public decimal aRMIndexMargin {get; set;}
    //    public decimal aRMQualifyingRate {get; set;}
    //    public string indexType {get; set;}
    //}
    
    // public class PaymentAdjustment{
    //    public integer paymentAdjustmentPeriodNumber {get; set;}
    //    public integer paymentAdjustmentDuration {get; set;}
    //    public integer paymentAdjustmentFrequency {get; set;}
    //    public string  paymentAdjustmentTypeCode {get; set;}
    //    public decimal paymentAdjustmentPercent {get; set;}
    //    public decimal paymentAdjustmentAmount {get; set;}
    //    public decimal paymentAdjustmentPercentCap {get; set;}
    //    public decimal paymentAdjustmentAmountCap {get; set;}
    //    public integer monthsToFirstPaymentAdjustment {get; set;}
    //}
    
    //public class RateAdjustment{
    //    public integer rateAdjustmentPeriodNumber {get; set;}
    //    public integer rateAdjustmentDuration {get; set;}
    //    public integer rateAdjustmentFrequency {get; set;}
    //    public string rateAdjustmentCalculationMethodCode {get; set;}
    //    public decimal rateAdjustmentPercent {get; set;}
    //    public decimal rateAdjustmentCap {get; set;}
    //    public integer monthsToFirstRateAdjustment {get; set;}
    //}
    
    //public class BuydownData{
    //    public integer buydownFrequency {get; set;}
    //    public integer buydownDuration {get; set;}
    //    public decimal increaseRate {get; set;}
    //    public boolean fundingCode {get; set;}
    //    public string buydownBaseDateCode {get; set;}
    //    public string buydownTypeIndicator {get; set;}
    //}
    
    //public class CasefileIdentification{
    //    public string filler {get; set;}
    //}
    
    //public class LenderData{
    //    public string fHALenderIdentifier {get; set;}
    //    public string fHASponsorIdentifier {get; set;}
    //    public string sponsoredOriginatorEIN {get; set;}
    //    public string filler {get; set;}
    //}
    
 
    //public class FHALoanOnlyData{
    //    public string fHASectionOfActCodes {get; set;}
    //    public string allowableRepairs {get; set;}
    //    public string mIPUpfrontPercent {get; set;}
    //    public decimal mIPRefundAmount {get; set;}
    //    public string firstRenewalRate {get; set;}
    //}
    
    //public class VALoanOnlyData{
    //    public boolean coBorrowerMarriedToPrimaryBorrower {get; set;}
    //    public decimal entitlementAmount {get; set;}
    //    public decimal monthlyMaintenance {get; set;}
    //    public decimal monthlyUtilities {get; set;}
    //    public string fundingFeePercent {get; set;}
    //}
    
    //public class VALoanOnlyExtraData{
    //    public string ssn {get; set;}
    //    public decimal totalTax {get; set;}
    //    public decimal stateTax {get; set;}
    //    public decimal localIncomeTax {get; set;}
    //    public decimal socialSecurityTax {get; set;}
    //    public decimal totalNonTaxableIncomePrimary {get; set;}
    //    public decimal totalNonTaxableIncomeOther {get; set;}
    //    public decimal totalTaxableIncomePrimary {get; set;}
    //    public decimal totalTaxableIncomeOther {get; set;}
    //}
    
    //public class CreditData{
    //    public string ssn {get; set;}
    //    public string cAIVRNumber {get; set;}
    //    public string borrowerCreditRating {get; set;}
    //    public string bankruptcyWithinLastThreeYears {get; set;}
    //    public string forclosure {get; set;}
    //    public string firstTimeHomebuyerCounsel {get; set;}
    //}
    
    //public class CommunityLendingLoanData{
    //    public string metropolitanStatisticalAreaOrCounty {get; set;}
    //    public string communityLendingProduct {get; set;}
    //    public string communitySecondsRepaymentStructure {get; set;}
    //    public boolean fannieNeighborsEligible {get; set;}
    //    public boolean communitySeconds {get; set;}
    //    public decimal hUDMedianIncome {get; set;}
    //    public decimal incomeLimitAdjustmentFactors {get; set;}
    //    public decimal communityLendingIncomeLimit {get; set;}
    //}
    
    //public class TransactionTrailer {
    //    public String transactionControlNumber {get; set;}
    //}
    
    //public class EnvelopeTrailer {
    //    public String envelopeControlNumber {get; set;}
    //}
    
    //public class FieldList {
    //    public Integer length {get; set;}
    //    public Integer position {get; set;}
    //    public String variableName {get; set;}
    //}
    
   
    
    //public class Warnings {
    //    public Integer lineNumber {get; set;}
    //    public String field {get; set;}
    //    public Integer length {get; set;}
    //    public Integer position {get; set;}
    //    public String errorMessage {get; set;}
    //    public Boolean highlightWarning {get; set;}
    //    public String variableName {get; set;}
    //} 
}
