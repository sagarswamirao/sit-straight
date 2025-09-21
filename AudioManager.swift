import AVFoundation
import Foundation

class AudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    func playReminderSound() {
        // Stop any existing audio first
        stopAudio()

        guard let url = Bundle.main.url(forResource: "reminder-posture-1", withExtension: "wav") else {
            print("Could not find reminder-posture-1.wav")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.7
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func playBlinkSound() {
        // Stop any existing audio first
        stopAudio()

        guard let url = Bundle.main.url(forResource: "reminder-blink-1", withExtension: "wav") else {
            print("Could not find reminder-blink-1.wav")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func playBreakReminderSound() {
        // Stop any existing audio first
        stopAudio()

        guard let url = Bundle.main.url(forResource: "notification-break-reminder", withExtension: "wav") else {
            print("Could not find notification-break-reminder.wav")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.8
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
