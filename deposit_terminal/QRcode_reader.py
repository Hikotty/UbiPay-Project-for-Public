import cv2
import numpy as np

def QRcode_reader():
    cap = cv2.VideoCapture(0)
    detector = cv2.QRCodeDetector()
    cv2.moveWindow('window name', 100, 100) 

    while True:
        frame, img = cap.read()
        output_img = img.copy()
        resized_img = cv2.resize(output_img,(1800, 1800))
        data, bbox, _ = detector.detectAndDecode(img)
        cv2.putText(resized_img, "Please hold up your QR code closer.", (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 3, (255, 255, 255), 1, cv2.LINE_AA)
    
        if data:
            #cv2.putText(output_img, data, (0, 20), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 5, cv2.LINE_AA)
            print(data)
            break
        cv2.imshow("Show your personal QRcode", resized_img)
        if cv2.waitKey(1) == ord("q"):
            break

    cap.release()
    cv2.destroyAllWindows()
    
    return data
