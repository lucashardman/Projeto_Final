/**
 * (C) Copyright IBM Corp. 2018, 2019.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation

/**
 Information about existing custom language models.
 */
public struct LanguageModels: Codable, Equatable {

    /**
     An array of `LanguageModel` objects that provides information about each available custom language model. The array
     is empty if the requesting credentials own no custom language models (if no language is specified) or own no custom
     language models for the specified language.
     */
    public var customizations: [LanguageModel]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case customizations = "customizations"
    }

}
