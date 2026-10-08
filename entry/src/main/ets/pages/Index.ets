import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct Index {
  @Local imageUri: string = '';
  @Local hint: string = 'Tap the button to pick a photo';
  private static readonly TAG: string = 'GalleryGuide';

  build() {
    Column({ space: 16 }) {
      if (this.imageUri.length > 0) {
        Image(this.imageUri)
          .width('70%')
          .objectFit(ImageFit.Contain)
          .borderRadius(12)
          .backgroundColor(Color.Gray)
      } else {
        Text(this.hint)
          .fontSize(14)
          .fontColor(Color.Gray)
          .width('70%')
          .textAlign(TextAlign.Center)
      }

      Button('Open gallery')
        .onClick(() => {
          this.pickImage();
        })
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding(16)
  }
  private async pickImage(): Promise<void> {
    try {
      const options = new photoAccessHelper.PhotoSelectOptions();
      options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // images only
      options.maxSelectNumber = 1;                                        // single selection

      const picker = new photoAccessHelper.PhotoViewPicker();
      const result: photoAccessHelper.PhotoSelectResult = await picker.select(options);
      // photoUris is empty when the user leaves without choosing anything.
      if (result.photoUris.length > 0) {
        this.imageUri = result.photoUris[0];
      } else {
        this.hint = 'No photo selected';
      }
    } catch (err) {
      const e = err as BusinessError;
      console.error(`${Index.TAG} gallery select failed: ${e.code} - ${e.message}`);
      this.hint = 'Could not open the gallery';
    }
  }
}