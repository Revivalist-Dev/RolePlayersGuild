using Amazon;
using Amazon.S3;
using Amazon.S3.IO;
using Amazon.S3.Transfer;
using System;
using System.Configuration;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace RolePlayersGuild
{
    public class ImageFunctions
    {
        private static readonly string BucketName = ConfigurationManager.AppSettings["AWSBucketName"];
        private static readonly string VirtualDir = ConfigurationManager.AppSettings["CharacterImagesFolder"];
        private static readonly RegionEndpoint AwsRegion = RegionEndpoint.GetBySystemName("us-east-2");

        private static AmazonS3Client GetS3Client()
        {
            string awsAccessKey = ConfigurationManager.AppSettings["AWSAccessKey"];
            string awsSecretKey = ConfigurationManager.AppSettings["AWSSecretKey"];
            return new AmazonS3Client(awsAccessKey, awsSecretKey, AwsRegion);
        }

        public static void DeleteImage(string imageName)
        {
            if (string.IsNullOrEmpty(imageName)) return;

            AmazonS3Client awsClient = GetS3Client();

            S3FileInfo s3FullFileInfo = new S3FileInfo(awsClient, BucketName, VirtualDir + "fullimg_" + imageName);
            if (s3FullFileInfo.Exists)
            {
                s3FullFileInfo.Delete();
            }

            S3FileInfo s3ThumbFileInfo = new S3FileInfo(awsClient, BucketName, VirtualDir + "thumbimg_" + imageName);
            if (s3ThumbFileInfo.Exists)
            {
                s3ThumbFileInfo.Delete();
            }
        }

        public static string UploadImage(FileUpload uploadedFile)
        {
            if (!uploadedFile.HasFile || uploadedFile.PostedFile.ContentLength == 0) return "";

            string mimeType = uploadedFile.PostedFile.ContentType.ToLowerInvariant();
            ImageFormat outputFormat = GetImageFormatFromMimeType(mimeType);
            string fileExtension = GetExtensionFromMimeType(mimeType);

            if (outputFormat == null) return ""; // Unsupported file type

            string uniqueFileName = GenerateUniqueS3FileName(fileExtension);
            if (string.IsNullOrEmpty(uniqueFileName)) return "";

            using (var originalBmp = new Bitmap(uploadedFile.FileContent))
            {
                UploadResizedImage(originalBmp, "fullimg_" + uniqueFileName, 900, 1200, outputFormat);
                UploadResizedImage(originalBmp, "thumbimg_" + uniqueFileName, 300, 300, outputFormat);
            }

            return uniqueFileName;
        }

        private static void UploadResizedImage(System.Drawing.Image originalImage, string s3Key, int maxWidth, int maxHeight, ImageFormat format)
        {
            using (Bitmap resizedBmp = ResizeImage(originalImage, maxWidth, maxHeight))
            using (var memoryStream = new MemoryStream())
            {
                if (format.Equals(ImageFormat.Jpeg))
                {
                    ImageCodecInfo jpegCodec = GetEncoderInfo("image/jpeg");
                    EncoderParameters encoderParams = new EncoderParameters(1);
                    encoderParams.Param[0] = new EncoderParameter(Encoder.Quality, 95L);
                    resizedBmp.Save(memoryStream, jpegCodec, encoderParams);
                }
                else
                {
                    resizedBmp.Save(memoryStream, format);
                }

                memoryStream.Position = 0;
                UploadStreamToS3(memoryStream, s3Key);
            }
        }

        private static void UploadStreamToS3(Stream stream, string s3Key)
        {
            using (var awsClient = GetS3Client())
            using (var fileTransferUtility = new TransferUtility(awsClient))
            {
                fileTransferUtility.Upload(stream, BucketName, VirtualDir + s3Key);
            }
        }

        private static Bitmap ResizeImage(System.Drawing.Image image, int maxWidth, int maxHeight)
        {
            var ratioX = (double)maxWidth / image.Width;
            var ratioY = (double)maxHeight / image.Height;
            var ratio = Math.Min(ratioX, ratioY);

            if (ratio >= 1.0) return new Bitmap(image);

            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            var newImage = new Bitmap(newWidth, newHeight);
            using (var graphics = Graphics.FromImage(newImage))
            {
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.SmoothingMode = SmoothingMode.HighQuality;
                graphics.DrawImage(image, 0, 0, newWidth, newHeight);
            }
            return newImage;
        }

        private static string GenerateUniqueS3FileName(string extension)
        {
            using (var awsClient = GetS3Client())
            {
                int fileNameLength = 4;
                while (fileNameLength < 10)
                {
                    string randomName = StringFunctions.GenerateRandomString(fileNameLength);
                    string fullFileName = randomName + extension;
                    S3FileInfo s3FileInfo = new S3FileInfo(awsClient, BucketName, VirtualDir + "fullimg_" + fullFileName);
                    if (!s3FileInfo.Exists)
                    {
                        return fullFileName;
                    }
                    fileNameLength++;
                }
            }
            return null; // Should realistically never happen
        }

        private static ImageCodecInfo GetEncoderInfo(string mimeType)
        {
            return ImageCodecInfo.GetImageEncoders().FirstOrDefault(codec => codec.MimeType == mimeType);
        }

        private static ImageFormat GetImageFormatFromMimeType(string mimeType)
        {
            switch (mimeType)
            {
                case "image/jpeg":
                case "image/jpg":
                    return ImageFormat.Jpeg;
                case "image/png":
                    return ImageFormat.Png;
                case "image/gif":
                    return ImageFormat.Gif;
                default:
                    return null;
            }
        }

        private static string GetExtensionFromMimeType(string mimeType)
        {
            switch (mimeType)
            {
                case "image/jpeg":
                case "image/jpg":
                    return ".jpg";
                case "image/png":
                    return ".png";
                case "image/gif":
                    return ".gif";
                default:
                    return "";
            }
        }
    }
}