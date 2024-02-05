import SwiftUI
import Foundation

struct ContentView: View {
    @State private var isActive: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Your content in ContentView
            }
            .navigationBarTitle("Content View")
        }
        .background(
            NavigationLink(
                destination: MainView(),
                isActive: $isActive,
                label: {
                    EmptyView()
                }
            )
            .hidden()
            .onAppear {
                // Set isActive to true to trigger the NavigationLink
                self.isActive = true
            }
        )
    }
}



extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}




class AppSettings: ObservableObject {
    
    @Published var selectedLanguage: AppLanguage {
            didSet {
                UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
            }
        }

        @Published var isDarkMode: Bool {
            didSet {
                UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
            }
        }


        init() {
            self.selectedLanguage = AppLanguage(rawValue: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "") ?? .english
            self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            
        }
}

struct SettingsView: View {
    @ObservedObject var appSettings: AppSettings
    @ObservedObject var localizedStrings: LocalizedStrings

    var body: some View {
        Form {
            Section(header: Text(localizedStrings.languageHeader)) {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        appSettings.selectedLanguage = language
                        localizedStrings.currentLanguage = language
                        print("Selected Language: \(appSettings.selectedLanguage.rawValue)")
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.title)
                            Text(language.rawValue)
                                .foregroundColor(appSettings.selectedLanguage == language ? .blue : .primary)
                        }
                    }
                }
            }

            
        }
        .navigationTitle("")
    }
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case arabic = "العربية"
    case urdu = "اردو"
    case hindi = "हिंदी"
    case turkish = "TÜRKÇE"
    case punjabi = "ਪੰਜਾਬੀ"
}

class LocalizedStrings: ObservableObject {
    @Published var currentLanguage: AppLanguage = .english
    static var shared = LocalizedStrings()
    
    var notRamadan: String {
        switch currentLanguage {
        case .english: return "It's not Ramadan"
        case .arabic: return "لم يحل شهر رمضان بعد"
        case .urdu: return "یہ رمضان نہیں ہے"
        case .hindi: return "यह रमज़ान नहीं है"
        case .turkish: return "Bu Ramazan değil"
        case .punjabi: return "ਇਹ ਰਮਜ਼ਾਨ ਨਹੀਂ ਹੈ"
        }
    }
    
    var timeLeft: String {
        switch currentLanguage {
        case .english: return "Ramadan starts at March 11, See you then"
        case .arabic: return "الوقت المتبقييبدأ شهر رمضان في ١١ مارس، أراك حينها"
        case .urdu: return "رمضان ۱۱ مارچ سے شروع ہوتا ہے، پھر ملتے ہیں۔"
        case .hindi: return "११ मार्च को रमज़ान है, फिर मिलते हैं"
        case .turkish: return "Ramazan 11 Mart'ta başlıyor, görüşmek üzere"
        case .punjabi: return "ਰਮਜ਼ਾਨ 11 ਮਾਰਚ ਨੂੰ ਸ਼ੁਰੂ ਹੁੰਦਾ ਹੈ, ਫਿਰ ਮਿਲਦੇ ਹਾਂ"
        }
    }
    
    var appearanceHeader: String {
        switch currentLanguage {
        case .english: return "Appearance"
        case .arabic: return "المظهر"
        case .urdu: return "ظہور"
        case .hindi: return "उपस्थिति"
        case .turkish: return "Görünüş"
        case .punjabi: return "ਦਿੱਖ"
        }
    }
    
    var darkModeToggle: String {
        switch currentLanguage {
        case .english: return "Dark Mode"
        case .arabic: return "الوضع المظلم"
        case .urdu: return "ڈارک موڈ"
        case .hindi: return "डार्क मोड"
        case .turkish: return "Karanlık mod"
        case .punjabi: return "ਡਾਰਕ ਮੋਡ"
        }
    }
    
    var textSizeHeader: String {
        switch currentLanguage {
        case .english: return "Text Size"
        case .arabic: return "حجم النص"
        case .urdu: return "متن کا سائز"
        case .hindi: return "टेक्स्ट का साइज़"
        case .turkish: return "Metin boyutu"
        case .punjabi: return "ਟੈਕਸਟ ਦਾ ਆਕਾਰ"
        }
    }
    
    var languageHeader: String {
        switch currentLanguage {
        case .english: return "Language"
        case .arabic: return "اللغة"
        case .urdu: return "زبان"
        case .hindi: return "भाषा"
        case .turkish: return "Dil"
        case .punjabi: return "ਭਾਸ਼ਾ"
        }
    }
    
    var timesForIftarAndSuhoor: String {
        switch currentLanguage {
        case .english: return "Below are the times for the next Suhoor and Iftar"
        case .arabic: return "فيما يلي مواعيد السحور والإفطار التاليين"
        case .urdu: return "اگلی سحری اور افطاری کے اوقات درج ذیل ہیں۔"
        case .hindi: return "अगली सुहूर और इफ्तार का समय नीचे दिया गया है"
        case .turkish: return "Bir sonraki Sahur ve İftar için saatler aşağıdadır"
        case .punjabi: return "ਹੇਠਾਂ ਅਗਲੇ ਸੁਹੂਰ ਅਤੇ ਇਫਤਾਰ ਦੇ ਸਮੇਂ ਹਨ"
        }
    }
    
    var iftar: String {
        switch currentLanguage {
        case .english: return "Iftar"
        case .arabic: return "الإفطار"
        case .urdu: return "افطار"
        case .hindi: return "इफ्तार"
        case .turkish: return "İftar"
        case .punjabi: return "ਇਫਤਾਰ"
        }
    }
    
    var suhoor: String {
        switch currentLanguage {
        case .english: return "Suhoor"
        case .arabic: return "السحور"
        case .urdu: return "سحری"
        case .hindi: return "सुहूर"
        case .turkish: return "Sahur"
        case .punjabi: return "ਸੁਹੂਰ"
        }
    }
    
    // Inside your LocalizedStrings class:
    
    var months: [String] {
        switch currentLanguage {
        case .english: return ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        case .arabic: return ["", "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو", "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"]
        case .urdu: return ["", "جنوری", "فروری", "مارچ", "اپریل", "مئی", "جون", "جولائی", "اگست", "ستمبر", "اکتوبر", "نومبر", "دسمبر"]
        case .hindi: return ["", "जनवरी", "फरवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"]
        case .turkish: return ["", "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
        case .punjabi: return ["", "جنوری", "فروری", "مارچ", "اپریل", "مئی", "جون", "جولائی", "اگست", "ستمبر", "اکتوبر", "نومبر", "دسمبر"]
            // Add translations for other languages
        }
    }
    
    var numbers: [String] {
        switch currentLanguage {
        case .english: return ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        case .arabic: return ["", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩", "١٠", "١١", "١٢", "١٣", "١٤", "١٥", "١٦", "١٧", "١٨", "١٩", "٢٠", "٢١", "٢٢", "٢٣", "٢٤", "٢٥", "٢٦", "٢٧", "٢٨", "٢٩", "٣٠", "٣١"]
        case .urdu: return ["", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩", "١٠", "١١", "١٢", "١٣", "١٤", "١٥", "١٦", "١٧", "١٨", "١٩", "٢٠", "٢١", "٢٢", "٢٣", "٢٤", "٢٥", "٢٦", "٢٧", "٢٨", "٢٩", "٣٠", "٣١"]
        case .hindi: return ["", "१", "२", "३", "४", "५", "६", "७", "८", "९", "१०", "११", "१२", "१३", "१४", "१५", "१६", "१७", "१८", "१९", "२०", "२१", "२२", "२३", "२४", "२५", "२६", "२७", "२८", "२९", "३०", "३१"]
        case .turkish: return ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        case .punjabi: return ["", "੧", "੨", "੩", "੪", "੫", "੬", "੭", "੮", "੯", "੧੦", "੧੧", "੧੨", "੧੩", "੧੪", "੧੫", "੧੬", "੧੭", "੧੮", "੧੯", "੨੦", "੨੧", "੨੨", "੨੩", "੨੪", "੨੫", "੨੬", "੨੭", "੨੮", "੨੯", "੩੦", "੩੧"]
            // Add translations for other languages
        }
    }
    
    func translatedStringForDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: currentLanguage.rawValue)

        var formattedString = dateFormatter.string(from: date)

        // Extract the time portion and translate
        if let range = formattedString.range(of: "at") {
            var timeSubstring = formattedString[range.upperBound...].trimmingCharacters(in: .whitespaces)
            
            // Check if it contains a day of the week and remove it
            let daysOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Fri", "Saturday"]
            for day in daysOfTheWeek {
                timeSubstring = timeSubstring.replacingOccurrences(of: day, with: "")
            }
            
            formattedString = translateMonthsAndNumbers(in: timeSubstring, language: currentLanguage)
        }

        return formattedString.trimmingCharacters(in: .whitespaces)
    }





    func translateMonthsAndNumbers(in text: String, language: AppLanguage) -> String {
        var translatedText = text

        switch language {
        case .arabic:
            translatedText = translatedText.replacingOccurrences(of: "January", with: "يناير")
            translatedText = translatedText.replacingOccurrences(of: "February", with: "فبراير")
            translatedText = translatedText.replacingOccurrences(of: "March", with: "مارس")
            translatedText = translatedText.replacingOccurrences(of: "April", with: "أبريل")
            translatedText = translatedText.replacingOccurrences(of: "May", with: "مايو")
            translatedText = translatedText.replacingOccurrences(of: "June", with: "يونيو")
            translatedText = translatedText.replacingOccurrences(of: "July", with: "يوليو")
            translatedText = translatedText.replacingOccurrences(of: "August", with: "أغسطس")
            translatedText = translatedText.replacingOccurrences(of: "September", with: "سبتمبر")
            translatedText = translatedText.replacingOccurrences(of: "October", with: "أكتوبر")
            translatedText = translatedText.replacingOccurrences(of: "November", with: "نوفمبر")
            translatedText = translatedText.replacingOccurrences(of: "December", with: "ديسمبر")
            
            // Translate numbers
            for i in 1...31 {
                translatedText = translatedText.replacingOccurrences(of: "\(i)", with: convertToArabicNumber(i))
            }

        case .urdu:
            // Translate months to Urdu
            translatedText = translatedText.replacingOccurrences(of: "January", with: "جنوری")
            translatedText = translatedText.replacingOccurrences(of: "February", with: "فروری")
            translatedText = translatedText.replacingOccurrences(of: "March", with: "مارچ")
            translatedText = translatedText.replacingOccurrences(of: "April", with: "اپریل")
            translatedText = translatedText.replacingOccurrences(of: "May", with: "مئی")
            translatedText = translatedText.replacingOccurrences(of: "June", with: "جون")
            translatedText = translatedText.replacingOccurrences(of: "July", with: "جولائی")
            translatedText = translatedText.replacingOccurrences(of: "August", with: "اگست")
            translatedText = translatedText.replacingOccurrences(of: "September", with: "ستمبر")
            translatedText = translatedText.replacingOccurrences(of: "October", with: "اکتوبر")
            translatedText = translatedText.replacingOccurrences(of: "November", with: "نومبر")
            translatedText = translatedText.replacingOccurrences(of: "December", with: "دسمبر")
            
            // Translate numbers
            for i in 1...31 {
                translatedText = translatedText.replacingOccurrences(of: "\(i)", with: convertToUrduNumber(i))
            }

        case .hindi:
            // Translate months to Hindi
            translatedText = translatedText.replacingOccurrences(of: "January", with: "जनवरी")
            translatedText = translatedText.replacingOccurrences(of: "February", with: "फरवरी")
            translatedText = translatedText.replacingOccurrences(of: "March", with: "मार्च")
            translatedText = translatedText.replacingOccurrences(of: "April", with: "अप्रैल")
            translatedText = translatedText.replacingOccurrences(of: "May", with: "मई")
            translatedText = translatedText.replacingOccurrences(of: "June", with: "जून")
            translatedText = translatedText.replacingOccurrences(of: "July", with: "जुलाई")
            translatedText = translatedText.replacingOccurrences(of: "August", with: "अगस्त")
            translatedText = translatedText.replacingOccurrences(of: "September", with: "सितंबर")
            translatedText = translatedText.replacingOccurrences(of: "October", with: "अक्टूबर")
            translatedText = translatedText.replacingOccurrences(of: "November", with: "नवंबर")
            translatedText = translatedText.replacingOccurrences(of: "December", with: "दिसंबर")
            
            // Translate numbers
            for i in 1...31 {
                translatedText = translatedText.replacingOccurrences(of: "\(i)", with: convertToHindiNumber(i))
            }

        case .turkish:
            // Translate months to Turkish
            translatedText = translatedText.replacingOccurrences(of: "January", with: "Ocak")
            translatedText = translatedText.replacingOccurrences(of: "February", with: "Şubat")
            translatedText = translatedText.replacingOccurrences(of: "March", with: "Mart")
            translatedText = translatedText.replacingOccurrences(of: "April", with: "Nisan")
            translatedText = translatedText.replacingOccurrences(of: "May", with: "Mayıs")
            translatedText = translatedText.replacingOccurrences(of: "June", with: "Haziran")
            translatedText = translatedText.replacingOccurrences(of: "July", with: "Temmuz")
            translatedText = translatedText.replacingOccurrences(of: "August", with: "Ağustos")
            translatedText = translatedText.replacingOccurrences(of: "September", with: "Eylül")
            translatedText = translatedText.replacingOccurrences(of: "October", with: "Ekim")
            translatedText = translatedText.replacingOccurrences(of: "November", with: "Kasım")
            translatedText = translatedText.replacingOccurrences(of: "December", with: "Aralık")
            
            // Translate numbers
            for i in 1...31 {
                translatedText = translatedText.replacingOccurrences(of: "\(i)", with: convertToTurkishNumber(i))
            }

        case .punjabi:
            // Translate months to Punjabi
            translatedText = translatedText.replacingOccurrences(of: "January", with: "ਜਨਵਰੀ")
            translatedText = translatedText.replacingOccurrences(of: "February", with: "ਫਰਵਰੀ")
            translatedText = translatedText.replacingOccurrences(of: "March", with: "ਮਾਰਚ")
            translatedText = translatedText.replacingOccurrences(of: "April", with: "ਅਪ੍ਰੈਲ")
            translatedText = translatedText.replacingOccurrences(of: "May", with: "ਮਈ")
            translatedText = translatedText.replacingOccurrences(of: "June", with: "ਜੂਨ")
            translatedText = translatedText.replacingOccurrences(of: "July", with: "ਜੁਲਾਈ")
            translatedText = translatedText.replacingOccurrences(of: "August", with: "ਅਗਸਤ")
            translatedText = translatedText.replacingOccurrences(of: "September", with: "ਸਤੰਬਰ")
            translatedText = translatedText.replacingOccurrences(of: "October", with: "ਅਕਤੂਬਰ")
            translatedText = translatedText.replacingOccurrences(of: "November", with: "ਨਵੰਬਰ")
            translatedText = translatedText.replacingOccurrences(of: "December", with: "ਦਸੰਬਰ")
            
            // Translate numbers
            for i in 1...31 {
                translatedText = translatedText.replacingOccurrences(of: "\(i)", with: convertToPunjabiNumber(i))
            }
        case .english:
            break
        }
        
        return translatedText
    }

    func convertToArabicNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ar")
        numberFormatter.numberStyle = .spellOut

        if let spelledOut = numberFormatter.string(from: NSNumber(value: number)) {
            return spelledOut
        }
        return "\(number)"
    }

    func convertToUrduNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "ur")
        numberFormatter.numberStyle = .spellOut

        if let spelledOut = numberFormatter.string(from: NSNumber(value: number)) {
            return spelledOut
        }
        return "\(number)"
    }

    func convertToHindiNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "hi")
        numberFormatter.numberStyle = .spellOut

        if let spelledOut = numberFormatter.string(from: NSNumber(value: number)) {
            return spelledOut
        }
        return "\(number)"
    }

    func convertToTurkishNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "tr")
        numberFormatter.numberStyle = .spellOut

        if let spelledOut = numberFormatter.string(from: NSNumber(value: number)) {
            return spelledOut
        }
        return "\(number)"
    }

    func convertToPunjabiNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pa")
        numberFormatter.numberStyle = .spellOut

        if let spelledOut = numberFormatter.string(from: NSNumber(value: number)) {
            return spelledOut
        }
        return "\(number)"
    }





}
    
    
    // please help me im doing it the manual way
    
    struct MainView: View {
        @ObservedObject private var localizedStrings = LocalizedStrings()
        @ObservedObject private var appSettings = AppSettings()
        @AppStorage("isDarkMode") private var isDarkMode = false
        
        // Manually set future dates
        var manuallySetSuhoorDatesAndTimes: [Date] = []
        var manuallySetIftarDatesAndTimes: [Date] = []
        
        init() {
            // Initialize manually set future dates in the init method
            manuallySetSuhoorDatesAndTimes = [
                createDate(month: 3, day: 11, hour: 4, minute: 43, second: 0),
                
                createDate(month: 3, day: 12, hour: 4, minute: 41, second: 0),
                
                createDate(month: 3, day: 13, hour: 4, minute: 38, second: 0),
                
                createDate(month: 3, day: 14, hour: 4, minute: 36, second: 0),
                
                createDate(month: 3, day: 15, hour: 4, minute: 34, second: 0),
                
                createDate(month: 3, day: 16, hour: 4, minute: 32, second: 0),
                
                createDate(month: 3, day: 17, hour: 4, minute: 29, second: 0),
                
                createDate(month: 3, day: 18, hour: 4, minute: 27, second: 0),
                
                createDate(month: 3, day: 19, hour: 4, minute: 25, second: 0),
                
                createDate(month: 3, day: 20, hour: 4, minute: 23, second: 0),
                
                createDate(month: 3, day: 21, hour: 4, minute: 21, second: 0),
                
                createDate(month: 3, day: 22, hour: 4, minute: 20, second: 0),
                
                createDate(month: 3, day: 23, hour: 4, minute: 18, second: 0),
                
                createDate(month: 3, day: 24, hour: 4, minute: 15, second: 0),
                
                createDate(month: 3, day: 25, hour: 4, minute: 13, second: 0),
                
                createDate(month: 3, day: 26, hour: 4, minute: 12, second: 0),
                
                createDate(month: 3, day: 27, hour: 4, minute: 09, second: 0),
                
                createDate(month: 3, day: 28, hour: 4, minute: 08, second: 0),
                
                createDate(month: 3, day: 29, hour: 4, minute: 06, second: 0),
                
                createDate(month: 3, day: 29, hour: 4, minute: 04, second: 0),
                
                createDate(month: 3, day: 30, hour: 5, minute: 02, second: 0),
                
                createDate(month: 3, day: 31, hour: 5, minute: 00, second: 0),
                
                createDate(month: 4, day: 1, hour: 4, minute: 58, second: 0),
                
                createDate(month: 4, day: 2, hour: 4, minute: 56, second: 0),
                
                createDate(month: 4, day: 3, hour: 4, minute: 53, second: 0),
                
                createDate(month: 4, day: 4, hour: 4, minute: 51, second: 0),
                
                createDate(month: 4, day: 5, hour: 4, minute: 49, second: 0),
                
                createDate(month: 4, day: 6, hour: 4, minute: 47, second: 0),
                
                createDate(month: 4, day: 7, hour: 4, minute: 44, second: 0),
                
                createDate(month: 4, day: 8, hour: 4, minute: 42, second: 0),
                
                createDate(month: 4, day: 9, hour: 4, minute: 40, second: 08),
                
                
            ]
            
            manuallySetIftarDatesAndTimes = [
                createDate(month: 3, day: 11, hour: 18, minute: 02, second: 0),
                
                createDate(month: 3, day: 12, hour: 18, minute: 04, second: 0),
                
                createDate(month: 3, day: 13, hour: 18, minute: 06, second: 0),
                
                createDate(month: 3, day: 14, hour: 18, minute: 07, second: 0),
                
                createDate(month: 3, day: 15, hour: 18, minute: 09, second: 0),
                
                createDate(month: 3, day: 16, hour: 18, minute: 11, second: 0),
                
                createDate(month: 3, day: 17, hour: 18, minute: 12, second: 0),
                
                createDate(month: 3, day: 18, hour: 18, minute: 14, second: 0),
                
                createDate(month: 3, day: 19, hour: 18, minute: 16, second: 0),
                
                createDate(month: 3, day: 20, hour: 18, minute: 18, second: 0),
                
                createDate(month: 3, day: 21, hour: 18, minute: 19, second: 0),
                
                createDate(month: 3, day: 22, hour: 18, minute: 21, second: 0),
                
                createDate(month: 3, day: 23, hour: 18, minute: 23, second: 0),
                
                createDate(month: 3, day: 24, hour: 18, minute: 24, second: 0),
                
                createDate(month: 3, day: 25, hour: 18, minute: 26, second: 0),
                
                createDate(month: 3, day: 26, hour: 18, minute: 28, second: 0),
                
                createDate(month: 3, day: 27, hour: 18, minute: 29, second: 0),
                
                createDate(month: 3, day: 28, hour: 18, minute: 31, second: 0),
                
                createDate(month: 3, day: 29, hour: 18, minute: 33, second: 0),
                
                createDate(month: 3, day: 29, hour: 18, minute: 34, second: 0),
                
                createDate(month: 3, day: 30, hour: 19, minute: 36, second: 0),
                
                createDate(month: 3, day: 31, hour: 19, minute: 38, second: 0),
                
                createDate(month: 4, day: 1, hour: 19, minute: 39, second: 0),
                
                createDate(month: 4, day: 2, hour: 19, minute: 41, second: 0),
                
                createDate(month: 4, day: 3, hour: 19, minute: 43, second: 0),
                
                createDate(month: 4, day: 4, hour: 19, minute: 44, second: 0),
                
                createDate(month: 4, day: 5, hour: 19, minute: 46, second: 0),
                
                createDate(month: 4, day: 6, hour: 19, minute: 48, second: 0),
                
                createDate(month: 4, day: 7, hour: 19, minute: 49, second: 0),
                
                createDate(month: 4, day: 8, hour: 19, minute: 51, second: 0),
                
                createDate(month: 4, day: 9, hour: 19, minute: 53, second: 08),
                
                
            ]
        }
        
        
        var body: some View {
            NavigationView {
                VStack {
                    Text(localizedStrings.timesForIftarAndSuhoor)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    // Display current date and time
                    
                    // Display the closest date and time from the manually set future dates
                    if let closestDate = closestSuhoorDateToToday() {
                        let formattedDate = localizedStrings.translatedStringForDate(closestDate)
                        Text("\(localizedStrings.suhoor): \(formattedDate)")
                            .padding()
                    }
                    
                    
                    
                    
                    
                    // give the code some space (im doing this not because of a stupid joke its so i can easily find which one is suhoor and which one is ifar)
                    
                    
                    
                    
                    
                    
                    
                    
                    // Display the closest date and time from the manually set iftar dates
                    if let closestIftarDate = closestIftarDateToToday() {
                        let formattedDate = localizedStrings.translatedStringForDate(closestIftarDate)
                        Text("\(localizedStrings.iftar): \(formattedDate)")
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                }
                .preferredColorScheme(.light)
                .onAppear {
                    localizedStrings.currentLanguage = appSettings.selectedLanguage
                }
                .onReceive(appSettings.$selectedLanguage) { _ in
                    localizedStrings.currentLanguage = appSettings.selectedLanguage
                    print("Selected Language: \(appSettings.selectedLanguage.rawValue)")
                }
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: SettingsView(appSettings: appSettings, localizedStrings: localizedStrings),
                        label: {
                            Image(systemName: "gear")
                                .font(.title)
                                .padding()
                        }
                    )
                )
            }
        }
        
        
        
        func formattedMonthAndDay(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            dateFormatter.locale = Locale(identifier: localizedStrings.currentLanguage.rawValue)
            let monthAndDayString = dateFormatter.string(from: date)

            return localizedStrings.translateMonthsAndNumbers(in: monthAndDayString, language: localizedStrings.currentLanguage)
        }

        func formattedTime(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: localizedStrings.currentLanguage.rawValue)
            let timeString = dateFormatter.string(from: date)

            return localizedStrings.translateMonthsAndNumbers(in: timeString, language: localizedStrings.currentLanguage)
        }


        
        
        
        func formattedCurrentDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter.string(from: Date())
        }
        
        
        // Helper function to create a Date instance with specific components
        func createDate(month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
            var components = DateComponents()
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute
            components.second = second
            
            let calendar = Calendar.current
            return calendar.date(from: components) ?? Date()
        }
        
        // Function to find the date closest to today
        func closestDateToToday() -> Date? {
            let now = Date()
            
            // Sort the dates based on their distance to the current date
            let sortedDates = manuallySetSuhoorDatesAndTimes.sorted(by: { $0.distance(to: now) > $1.distance(to: now) })
            
            // Pick the first (closest) date
            return sortedDates.first
        }
        
        func otherSuhoorDatesOnSameDate() -> [Date] {
            guard let closestSuhoorDate = closestDateToToday() else { return [] }
            return manuallySetSuhoorDatesAndTimes.filter { Calendar.current.isDate($0, inSameDayAs: closestSuhoorDate) && $0 != closestSuhoorDate }
        }
        
        // Function to find Iftar times on the same date
        func iftarDatesOnSameDate() -> [Date] {
            guard let closestSuhoorDate = closestDateToToday() else { return [] }
            return manuallySetIftarDatesAndTimes.filter { Calendar.current.isDate($0, inSameDayAs: closestSuhoorDate) }
        }
        func closestSuhoorDateToToday() -> Date? {
            let now = Date()
            
            // Sort the suhoor dates based on their distance to the current date
            let sortedSuhoorDates = manuallySetSuhoorDatesAndTimes.sorted(by: { $0.distance(to: now) > $1.distance(to: now) })
            
            // Pick the first (closest) suhoor date
            return sortedSuhoorDates.first
        }
        
        // Function to find the closest iftar date to today
        func closestIftarDateToToday() -> Date? {
            let now = Date()
            
            // Sort the iftar dates based on their distance to the current date
            let sortedIftarDates = manuallySetIftarDatesAndTimes.sorted(by: { $0.distance(to: now) > $1.distance(to: now) })
            
            // Pick the first (closest) iftar date
            return sortedIftarDates.first
        }
    }
    
    

extension String {
    func translateMonthsAndNumbers(language: AppLanguage) -> String {
        var translatedText = self

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language.rawValue)

        // Translate months
        for month in dateFormatter.monthSymbols.enumerated() {
            translatedText = translatedText.replacingOccurrences(of: month.element, with: dateFormatter.standaloneMonthSymbols[month.offset])
        }

        // Translate numbers
        for number in 0...31 {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: language.rawValue)
            if let spelledOutNumber = numberFormatter.string(from: NSNumber(value: number)) {
                translatedText = translatedText.replacingOccurrences(of: "\(number)", with: spelledOutNumber)
            }
        }

        return translatedText
    }
}
