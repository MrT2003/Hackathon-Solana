import crypto from 'crypto';

// Hàm mã hóa secretKey
// export const encryptSecretKey = (secretKey, encryptionKey) => {
//   try {
//     // Tạo IV (Initialization Vector) ngẫu nhiên cho mỗi lần mã hóa
//     const iv = crypto.randomBytes(16); // 16-byte IV
//     const key = Buffer.from(encryptionKey, 'hex'); // ✅ Giải mã hex

//     const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
    
//     // Mã hóa secretKey (chuyển thành chuỗi JSON trước)
//     let encrypted = cipher.update(JSON.stringify(secretKey), 'utf8', 'hex');
//     encrypted += cipher.final('hex');
    
//     // Trả về IV và dữ liệu mã hóa (cả hai cần để giải mã sau này)
//     return {
//       iv: iv.toString('hex'),
//       encryptedData: encrypted
//     };
//   } catch (error) {
//     throw new Error('Lỗi khi mã hóa secretKey: ' + error.message);
//   }
// };

export const encryptSecretKey = (secretKey, encryptionKey) => {
  try {
    // Tạo IV ngẫu nhiên
    const iv = crypto.randomBytes(16);
    
    // Xử lý encryptionKey để đảm bảo đúng 32 bytes
    let key;
    if (typeof encryptionKey === 'string') {
      if (encryptionKey.length === 64) {
        // Nếu là hex string 64 ký tự (32 bytes)
        key = Buffer.from(encryptionKey, 'hex');
      } else {
        // Nếu là string thường, hash để có 32 bytes
        key = crypto.createHash('sha256').update(encryptionKey).digest();
      }
    } else {
      // Nếu đã là Buffer, kiểm tra độ dài
      key = Buffer.from(encryptionKey);
      if (key.length !== 32) {
        key = crypto.createHash('sha256').update(key).digest();
      }
    }
    
    // Kiểm tra key có đúng 32 bytes không
    if (key.length !== 32) {
      throw new Error(`Key phải có độ dài 32 bytes, hiện tại: ${key.length} bytes`);
    }
    
    const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
    
    let encrypted = cipher.update(JSON.stringify(secretKey), 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    return {
      iv: iv.toString('hex'),
      encryptedData: encrypted
    };
  } catch (error) {
    throw new Error('Lỗi khi mã hóa secretKey: ' + error.message);
  }
};

// Hàm giải mã secretKey (dùng khi cần truy cập secretKey)
export const decryptSecretKey = (encryptedData, iv, encryptionKey) => {
  try {
    const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(encryptionKey), Buffer.from(iv, 'hex'));
    let decrypted = decipher.update(encryptedData, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return JSON.parse(decrypted); // Chuyển về mảng byte gốc
  } catch (error) {
    throw new Error('Lỗi khi giải mã secretKey: ' + error.message);
  }
};

