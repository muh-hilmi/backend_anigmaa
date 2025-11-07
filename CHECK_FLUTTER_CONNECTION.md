# Flutter Connection Troubleshooting

## Backend is Running ✅
- Backend running on: `http://localhost:8081`
- Container internal port: `8080`
- Container exposed to host: `8081`

## Why Flutter Can't Connect? 🔍

### For Android Emulator:
Android emulator doesn't recognize `localhost` as the host machine.

**Solution:**
```dart
// ❌ Wrong
const String baseUrl = 'http://localhost:8081';
const String baseUrl = 'http://127.0.0.1:8081';

// ✅ Correct
const String baseUrl = 'http://10.0.2.2:8081';
```

### For Physical Device (Android/iOS):
Must use your computer's actual IP address on the network.

**Find your IP address:**

**Windows (WSL):**
```bash
# In WSL terminal
ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1

# Or in Windows CMD/PowerShell
ipconfig
# Look for "IPv4 Address" under your active network adapter
```

**Example:**
```dart
// If your computer IP is 192.168.1.100
const String baseUrl = 'http://192.168.1.100:8081';
```

## Where to Update in Flutter App?

Common locations:
1. `lib/core/constants/api_constants.dart`
2. `lib/config/api_config.dart`
3. `lib/services/api_service.dart`
4. `.env` file (if using environment variables)

## Quick Test

After updating the base URL, test the connection:
```bash
# From your computer
curl http://localhost:8081/health

# From Android emulator (using adb shell)
curl http://10.0.2.2:8081/health

# From physical device (replace with your IP)
curl http://192.168.1.100:8081/health
```

## Docker Compose Version Fixed ✅

Removed obsolete `version: '3.8'` line from docker-compose.yml.
