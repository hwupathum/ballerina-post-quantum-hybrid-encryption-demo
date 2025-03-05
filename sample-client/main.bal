import ballerina/crypto;
import ballerina/http;
import ballerina/io;

configurable string mlKemKeystore = "../keystores/mlkem-cert.pem";
configurable string rsaKeystore = "../keystores/rsa-cert.pem";

function encryptPayload(string message) returns crypto:HybridEncryptionResult|error {

    crypto:PublicKey kyberPublicKey = check crypto:decodeMlKem768PublicKeyFromCertFile(mlKemKeystore);
    crypto:PublicKey rsaPublicKey = check crypto:decodeRsaPublicKeyFromCertFile(rsaKeystore);
    return crypto:encryptRsaKemMlKem768Hpke(message.toBytes(), rsaPublicKey, kyberPublicKey);
}

public function main() returns error? {

    http:Client cryptoClient = check new ("localhost:9090");
    string message = "Hello from Ballerina client";

    crypto:HybridEncryptionResult encryptionResult = check encryptPayload(message);
    string ciphertext = encryptionResult.cipherText.toBase64();
    string encapsulatedSecret = encryptionResult.encapsulatedSecret.toBase64();

    http:Response unionResult = check cryptoClient->/api.post({
        ciphertext,
        encapsulatedSecret
    });
    
    io:println("Encalsulated secret: ", encapsulatedSecret, "\n");
    io:println("Ciphertext: ", ciphertext, "\n");
    io:println("Status: ", unionResult.statusCode);
}