/*
	File:  AVAssetTrack.h

	Framework:  AVFoundation
 
	Copyright 2010 Apple Inc. All rights reserved.

*/


/*
	AVAssetTrack provides the track-level inspection interface for all assets.

*/

#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVAsynchronousKeyValueLoading.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetTrackSegment.h>
#import <CoreMedia/CMTimeRange.h>


@class AVAssetTrackInternal;

@interface AVAssetTrack : NSObject <NSCopying, AVAsynchronousKeyValueLoading>
{
@private
	AVAssetTrackInternal     *_track;
}

/* provides a reference to the AVAsset of which the AVAssetTrack is a part  */
@property (nonatomic, readonly) AVAsset *asset;

/* indicates the persistent unique identifier for this track of the asset  */
@property (nonatomic, readonly) CMPersistentTrackID trackID;

/* Note that cancellation of loading requests for all keys of AVAssetTrack must be made on the parent AVAsset, e.g. [[track.asset] cancelLoading] */

@end


@interface AVAssetTrack (AVAssetTrackBasicPropertiesAndCharacteristics)

/* indicates the media type for this track,
   from a predefined set of strings, e.g. AVMediaTypeVideo, AVMediaTypeAudio, etc. (see UTI note below) */
@property (nonatomic, readonly) NSString *mediaType;

/* provides an array of CMFormatDescriptions
   each of which indicates the format of media samples referenced by the track;
   a track that presents uniform media, e.g. encoded according to the same encoding settings,
   will provide an array with a count of 1 */
@property (nonatomic, readonly) NSArray *formatDescriptions;

/* indicates whether the track is enabled according to state stored in its container or construct;
   note that its presentation state can be changed from this default via AVPlayerItem */
@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;

/* indicates whether the track references sample data only within its storage container */
@property (nonatomic, readonly, getter=isSelfContained) BOOL selfContained;

/* indicates the total number of bytes of sample data required by the track */
@property (nonatomic, readonly) long long totalSampleDataLength;

/*!
	@method			hasMediaCharacteristic:
	@abstract		Reports whether the track references media with the specified media characteristic.
	@param			mediaCharacteristic
					The media characteristic of interest, e.g. AVMediaCharacteristicVisual, AVMediaCharacteristicAudible, AVMediaCharacteristicLegible, etc.,
					as defined above.
	@result			YES if the track references media with the specified characteristic, otherwise NO.
*/
- (BOOL)hasMediaCharacteristic:(NSString *)mediaCharacteristic;

@end


@interface AVAssetTrack (AVAssetTrackTemporalProperties)

/* Indicates the timeRange of the track within the overall timeline of the asset;
   a track with CMTimeCompare(timeRange.start, kCMTimeZero) == 1 will initially present an empty timeRange. */
@property (nonatomic, readonly) CMTimeRange timeRange;

/*	indicates a timescale in which time values for the track can be operated upon without extraneous numerical conversion  */
@property (nonatomic, readonly) CMTimeScale naturalTimeScale;

/* indicates the estimated data rate of the media data referenced by the track, in units of bits per second */
@property (nonatomic, readonly) float estimatedDataRate;

@end


@interface AVAssetTrack (AVAssetTrackLanguageProperties)

/* indicates the language associated with the track, as an ISO 639-2/T language code;
   may be nil if no language is indicated */
@property (nonatomic, readonly) NSString *languageCode;

/* indicates the language tag associated with the track, as an RFC 4646 language tag;
   may be nil if no language tag is indicated */
@property (nonatomic, readonly) NSString *extendedLanguageTag;

@end


@interface AVAssetTrack (AVAssetTrackPropertiesForVisualCharacteristic)

/* indicates the natural dimensions of the media data referenced by the track as a CGSize */
@property (nonatomic, readonly) CGSize naturalSize;

/* indicates the transform specified in the track's storage container as the preferred transformation of the visual media data for display purposes;
   its value is often but not always CGAffineTransformIdentity */
@property (nonatomic, readonly) CGAffineTransform preferredTransform;

@end


@interface AVAssetTrack (AVAssetTrackPropertiesForAudibleCharacteristic)

/* indicates the volume specified in the track's storage container as the preferred volume of the audible media data */
@property (nonatomic, readonly) float preferredVolume;

@end


@interface AVAssetTrack (AVAssetTrackPropertiesForFrameBasedCharacteristic)

/* indicates the frame rate of the track, in units of frames per second */
@property (nonatomic, readonly) float nominalFrameRate;

@end


@interface AVAssetTrack (AVAssetTrackSegments)

/* Provides an array of AVAssetTrackSegments with time mappings from the timeline of the track's media samples to the timeline of the track.
   Empty edits, i.e. timeRanges for which no media data is available to be presented, have a value of AVAssetTrackSegment.empty equal to YES. */
@property (nonatomic, copy, readonly) NSArray *segments;

/*!
	@method			segmentForTrackTime:
	@abstract		Supplies the AVAssetTrackSegment from the segments array that corresponds to the specified track time.
	@param			trackTime
					The trackTime for which an AVAssetTrackSegment is requested.
	@result			An AVAssetTrackSegment; will be nil if the trackTime is out of range
*/
- (AVAssetTrackSegment *)segmentForTrackTime:(CMTime)trackTime;

/*!
	@method			samplePresentationTimeForTrackTime:
	@abstract		Maps the specified trackTime through the appropriate time mapping and returns the resulting sample presentation time.
	@param			trackTime
					The trackTime for which a sample presentation time is requested.
	@result			A CMTime; will be invalid if the trackTime is out of range
*/
- (CMTime)samplePresentationTimeForTrackTime:(CMTime)trackTime;

@end


@interface AVAssetTrack (AVAssetTrackMetadataReading)

// high-level access to selected metadata of common interest

/* provides access to an array of AVMetadataItems for each common metadata key for which a value is available */
@property (nonatomic, readonly) NSArray *commonMetadata;

/* provides an NSArray of NSStrings, each representing a format of metadata that's available for the track (e.g. QuickTime userdata, etc.)
   Metadata formats are defined in AVMetadataItem.h. */
@property (nonatomic, readonly) NSArray *availableMetadataFormats;

/*!
	@method			metadataForFormat:
	@abstract		Provides an NSArray of AVMetadataItems, one for each metadata item in the container of the specified format.
	@param			format
					The metadata format for which items are requested.
	@result			An NSArray containing AVMetadataItems; may be nil if there is no metadata of the specified format.
	@discussion		Becomes callable without blocking when the key @"availableMetadataFormats" has been loaded
*/
- (NSArray *)metadataForFormat:(NSString *)format;

@end
