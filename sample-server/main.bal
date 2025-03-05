import ballerina/crypto;
import ballerina/http;
import ballerina/io;
import ballerina/lang.array;

configurable string mlKemKeystore = "../keystores/mlkem-keystore.p12";
configurable string rsaKeystore = "../keystores/rsa-keystore.p12";
configurable string keystorePassword = ?;
configurable string alias = "alias";

type EncryptedPayload readonly & record {
    string ciphertext;
    string encapsulatedSecret;
};

function decryptPayload(byte[] encapsulatedSecret, byte[] ciphertext) returns byte[]|error {

    crypto:KeyStore kyberKeyStore = {
        path: mlKemKeystore,
        password: keystorePassword
    };
    crypto:KeyStore rsaKeyStore = {
        path: rsaKeystore,
        password: keystorePassword
    };
    crypto:PrivateKey kyberPrivateKey = check crypto:decodeMlKem768PrivateKeyFromKeyStore(kyberKeyStore, alias, keystorePassword);
    crypto:PrivateKey rsaPrivateKey = check crypto:decodeRsaPrivateKeyFromKeyStore(rsaKeyStore, alias, keystorePassword);
    return crypto:decryptRsaKemMlKem768Hpke(ciphertext, encapsulatedSecret, rsaPrivateKey, kyberPrivateKey);
}

function parsePayload(EncryptedPayload payload) returns string|error {
    byte[] encapsulatedSecret = check array:fromBase64(payload.encapsulatedSecret);
    byte[] ciphertext = check array:fromBase64(payload.ciphertext);

    io:println("Ciphertext: ", ciphertext.toBase64(), "\n");
    byte[] plaintext = check decryptPayload(encapsulatedSecret, ciphertext);
    return string:fromBytes(plaintext);
}

service / on new http:Listener(9090) {
    resource function post api(EncryptedPayload payload) returns string|error {
        string plaintext = check parsePayload(payload);
        io:println("Plaintext: ", plaintext);
        return plaintext;
    }
}